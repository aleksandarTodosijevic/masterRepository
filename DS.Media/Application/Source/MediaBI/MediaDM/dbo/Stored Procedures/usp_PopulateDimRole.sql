CREATE PROCEDURE [dbo].[usp_PopulateDimRole]
AS
	
	DECLARE @DeletedOn AS DATETIME = GETDATE();

	IF OBJECT_ID('tempdb..#DimRole') IS NOT NULL DROP TABLE #DimRole

	SELECT * INTO #DimRole FROM dbo.DimRole WHERE 1 = 2;


	INSERT INTO #DimRole
		(RoleKey, NameOfRole, CommentOfRole, HashKey, DeletedOn)
	SELECT
	      RoleKey
		 ,NameOfRole
		 ,CommentOfRole
		 ,dbo.ufn_GetHashDimRole(RoleKey, NameOfRole, CommentOfRole) AS HashKey
		 ,NULL AS DeletedOn

	FROM (
	SELECT 
		dbo.CreateKeyFromSourceID(Id) AS RoleKey
		,[Description] AS [NameOfRole]
		,[Comment] AS [CommentOfRole]
	FROM [$(MediaDMStaging)].[dbo].[Role_lu] 
	WHERE StatusId = 1
	UNION ALL
	SELECT 
		dbo.CreateKeyFromSourceID(-1) AS RoleKey
		,'N/A' AS [Name Of Role]
		,'N/A' AS [Comment Of Role]
	) tt;


	MERGE 
		dbo.DimRole t
	USING 
		#DimRole s ON (t.RoleKey = s.RoleKey)
	WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
		UPDATE SET
	      t.RoleKey = s.RoleKey
		 ,t.NameOfRole = s.NameOfRole
		 ,t.CommentOfRole = s.CommentOfRole
		 ,t.HashKey = s.HashKey
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (RoleKey, NameOfRole, CommentOfRole, HashKey)
		VALUES (s.RoleKey, s.NameOfRole, s.CommentOfRole, s.HashKey)
	WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
		 UPDATE SET t.DeletedOn = @DeletedOn;


	RETURN 0

GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimRole] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimRole] TO [DataServices]
    AS [dbo];
GO

