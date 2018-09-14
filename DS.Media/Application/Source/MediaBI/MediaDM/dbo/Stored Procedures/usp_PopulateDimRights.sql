cReATE PROCEDURE [dbo].[usp_PopulateDimRights]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

DROP TABLE IF EXISTS #DimRights

SELECT 
	 RightsTreeKey
	,RightsTreeId
	,RightsTreeParentId
	,RightsName
    ,dbo.ufn_GetHashDimRights(RightsTreeKey, RightsTreeId, RightsTreeParentId, RightsName) AS HashKey
    ,NULL AS DeletedOn
	INTO #DimRights
FROM (
	SELECT 
		 dbo.CreateKeyFromSourceID(tt.Id) AS [RightsTreeKey]
		,tt.Id AS [RightsTreeId]
		,ParentId AS [RightsTreeParentId]
		,t.[Description] AS [RightsName]
	FROM [$(MediaDMStaging)].[dbo].[RightsTree_lu] tt
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Rights_lu] t ON tt.RightsId = t.Id
	WHERE tt.StatusId = 1
) AS tt

MERGE 
    dbo.DimRights t
USING 
    #DimRights s ON (t.[RightsTreeKey] = s.[RightsTreeKey])
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.[RightsTreeId] = s.[RightsTreeId]
		,t.[RightsTreeParentId] = s.[RightsTreeParentId]
		,t.[RightsName] = s.[RightsName]
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([RightsTreeKey], [RightsTreeId], [RightsTreeParentId], [RightsName], HashKey)
    VALUES (s.[RightsTreeKey], s.[RightsTreeId], s.[RightsTreeParentId], s.[RightsName], s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0