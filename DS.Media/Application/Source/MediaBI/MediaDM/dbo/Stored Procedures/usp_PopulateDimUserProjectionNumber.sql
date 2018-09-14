CREATE PROCEDURE [dbo].[usp_PopulateDimUserProjectionNumber]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimUserProjectionNumber') IS NOT NULL DROP TABLE #DimUserProjectionNumber

SELECT * INTO #DimUserProjectionNumber FROM dbo.DimUserProjectionNumber WHERE 1 = 2;


INSERT INTO [#DimUserProjectionNumber]
           ([UserProjectionNumberKey]
		   ,[ProjectionNumberNo]
           ,[ProjectionNumber]
		   ,[HashKey]
		   ,[DeletedOn]
		   )
SELECT 
			[UserProjectionNumberKey]
		   ,[ProjectionNumberNo]
           ,[ProjectionNumber]
	       ,dbo.ufn_GetHashDimUserProjectionNumber([UserProjectionNumberKey], [ProjectionNumberNo], [ProjectionNumber]) AS HashKey
           ,NULL AS DeletedOn

FROM (

SELECT DISTINCT
	dbo.CreateKeyFromSourceID(upn.Id) AS UserProjectionNumberKey,
	COALESCE(upn.ProjectionNo,'Unknown') AS [ProjectionNumberNo], 
	COALESCE(pn.[Description],'Unknown') AS [ProjectionNumber]
FROM [$(MediaDMStaging)].[dbo].UserProjectionNumber upn
INNER JOIN [$(MediaDMStaging)].[dbo].ProjectionNumber pn ON pn.Id = upn.ProjectionNo
INNER JOIN [$(MediaDMStaging)].[dbo].[User] u ON u.Id = upn.UserId

UNION ALL

SELECT
	dbo.CreateKeyFromSourceID('Unknown') AS UserProjectionNumberKey,
	'Unknown' AS ProjectionNumberNo,
	'Unknown' AS ProjectionNumber
) tt;

MERGE 
    dbo.DimUserProjectionNumber t
USING 
    #DimUserProjectionNumber s ON (t.UserProjectionNumberKey = s.UserProjectionNumberKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
	 	 t.UserProjectionNumberKey = s.UserProjectionNumberKey
		,t.ProjectionNumberNo = s.ProjectionNumberNo
        ,t.ProjectionNumber = s.ProjectionNumber
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (UserProjectionNumberKey, ProjectionNumberNo, ProjectionNumber, HashKey)
    VALUES (s.UserProjectionNumberKey, s.ProjectionNumberNo, s.ProjectionNumber, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;

GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimUserProjectionNumber] TO [DataServices]
    AS [dbo];
GO
