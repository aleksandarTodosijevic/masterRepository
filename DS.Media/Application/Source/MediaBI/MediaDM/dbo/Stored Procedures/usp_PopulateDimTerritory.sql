CREATE PROCEDURE [dbo].[usp_PopulateDimTerritory]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

DROP TABLE IF EXISTS #DimTerritory

SELECT 
	 TerritoryTreeKey
	,TerritoryTreeId
	,TerritoryTreeParentId
	,TerritoryName
    ,dbo.ufn_GetHashDimTerritory(TerritoryTreeKey, TerritoryTreeId, TerritoryTreeParentId, TerritoryName) AS HashKey
    ,NULL AS DeletedOn
	INTO #DimTerritory
FROM (
	SELECT 
		dbo.CreateKeyFromSourceID(tt.Id) AS [TerritoryTreeKey]
		,tt.Id AS [TerritoryTreeId]
		,ParentId AS [TerritoryTreeParentId]
		,t.[Description] AS [TerritoryName]
	FROM [$(MediaDMStaging)].[dbo].[TerritoryTree_lu] tt
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Territory_lu] t ON tt.TerritoryId = t.Id
	WHERE tt.StatusId = 1
) AS tt

MERGE 
    dbo.DimTerritory t
USING 
    #DimTerritory s ON (t.[TerritoryTreeKey] = s.[TerritoryTreeKey])
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.[TerritoryTreeId] = s.[TerritoryTreeId]
		,t.[TerritoryTreeParentId] = s.[TerritoryTreeParentId]
		,t.[TerritoryName] = s.[TerritoryName]
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TerritoryTreeKey], [TerritoryTreeId], [TerritoryTreeParentId], [TerritoryName], HashKey)
    VALUES (s.[TerritoryTreeKey], s.[TerritoryTreeId], s.[TerritoryTreeParentId], s.[TerritoryName], s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimTerritory] TO [ETLRole]
    AS [dbo];
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimTerritory] TO [DataServices]
    AS [dbo];
GO
