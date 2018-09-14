CREATE PROCEDURE [dbo].[usp_PopulateDimProjectionAnticipated]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimProjectionAnticipated') IS NOT NULL DROP TABLE #DimProjectionAnticipated

SELECT * INTO #DimProjectionAnticipated FROM dbo.DimProjectionAnticipated WHERE 1 = 2;


INSERT INTO #DimProjectionAnticipated
SELECT 
	 ProjectionAnticipatedKey
	,CreatedDateOfAnticipated
	,AnticipatedAmountCreatedBy
	,UpdatedDateOfAnticipated
	,AnticipatedAmountUpdatedBy
	,IsAppearInTotal
    ,dbo.ufn_GetHashDimProjectionAnticipated(ProjectionAnticipatedKey, CreatedDateOfAnticipated, AnticipatedAmountCreatedBy, UpdatedDateOfAnticipated, AnticipatedAmountUpdatedBy,IsAppearInTotal) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(p.[Id]) AS ProjectionAnticipatedKey, 
	p.[CreatedDate] AS CreatedDateOfAnticipated,
	CASE
		WHEN p.CreatedBy = 1 THEN
			'System User'
		ELSE
			uc.Firstname + ' ' + uc.Lastname 
	END AS AnticipatedAmountCreatedBy,
	COALESCE(p.[UpdatedDate], '1900-01-01') AS UpdatedDateOfAnticipated,
	COALESCE(CASE
		WHEN p.UpdatedBy = 1 THEN
			'System User'
		ELSE
			uu.Firstname + ' ' + uu.Lastname 
	END , 'N/A') AS AnticipatedAmountUpdatedBy
	,CASE 
		WHEN p.AppearAmountInTotal = 1 THEN 'Yes' 
		WHEN p.AppearAmountInTotal = 0 THEN 'No'
		ELSE 'N/A'
	END AS IsAppearInTotal
FROM
[$(MediaDMStaging)].[dbo].[Projection] p
LEFT JOIN [$(MediaDMStaging)].[dbo].[User] uc ON p.[CreatedBy] = uc.[Id]
LEFT JOIN [$(MediaDMStaging)].[dbo].[User] uu ON p.[UpdatedBy] = uu.[Id]
WHERE p.StatusId = 1
UNION ALL
SELECT 
	dbo.CreateKeyFromSourceID(-1) , '1900-01-01', 'N/A', '1900-01-01', 'N/A', 'N/A'
) tt;



MERGE 
    dbo.DimProjectionAnticipated t
USING 
    #DimProjectionAnticipated s ON (t.ProjectionAnticipatedKey = s.ProjectionAnticipatedKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.ProjectionAnticipatedKey = s.ProjectionAnticipatedKey
		,t.CreatedDateOfAnticipated = s.CreatedDateOfAnticipated
		,t.AnticipatedAmountCreatedBy = s.AnticipatedAmountCreatedBy
		,t.UpdatedDateOfAnticipated = s.UpdatedDateOfAnticipated
		,t.AnticipatedAmountUpdatedBy = s.AnticipatedAmountUpdatedBy
		,t.IsAppearInTotal = s.IsAppearInTotal
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProjectionAnticipatedKey, CreatedDateOfAnticipated, AnticipatedAmountCreatedBy, UpdatedDateOfAnticipated, AnticipatedAmountUpdatedBy, IsAppearInTotal, HashKey)
    VALUES (s.ProjectionAnticipatedKey, s.CreatedDateOfAnticipated, s.AnticipatedAmountCreatedBy, s.UpdatedDateOfAnticipated, s.AnticipatedAmountUpdatedBy, s.IsAppearInTotal, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimProjectionAnticipated] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimProjectionAnticipated] TO [DataServices]
    AS [dbo];
GO
