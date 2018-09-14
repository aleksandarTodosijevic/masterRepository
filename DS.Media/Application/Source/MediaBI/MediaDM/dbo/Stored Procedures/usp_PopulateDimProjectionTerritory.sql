CREATE PROCEDURE [dbo].[usp_PopulateDimProjectionTerritory]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimProjectionTerritory') IS NOT NULL DROP TABLE #DimProjectionTerritory

SELECT * INTO #DimProjectionTerritory FROM dbo.DimProjectionTerritory WHERE 1 = 2;


INSERT INTO #DimProjectionTerritory (ProjectionTerritoryKey, SourceTerritoryId, TerritoryRegion, TerritoryName, TerritoryTreeId, TerritoryTreeParentId , HashKey, DeletedOn)
	SELECT 
	  ProjectionTerritoryKey, 
	  SourceTerritoryId, 
	  TerritoryRegion, 
	  TerritoryName,
	  TerritoryTreeId,
	  TerritoryTreeParentId,
	  dbo.ufn_GetHashDimProjectionTerritory(ProjectionTerritoryKey, SourceTerritoryId, TerritoryRegion, TerritoryName, TerritoryTreeId, TerritoryTreeParentId ) AS HashKey,
	  NULL AS DeletedOn
	FROM (  
	SELECT
		dbo.CreateKeyFromSourceID(tree.[TerritoryId]) as ProjectionTerritoryKey
		,tree.Id AS TerritoryTreeId
		,tree.ParentId AS TerritoryTreeParentId
		,tree.[TerritoryId] as SourceTerritoryId 
		,r.[Description] as TerritoryRegion 
		,t.[Description] as TerritoryName
	FROM [$(MediaDMStaging)].dbo.ProjectionTerritoryTree_lu tree
	JOIN [$(MediaDMStaging)].dbo.Territory_lu t ON t.Id = tree.TerritoryId
	JOIN [$(MediaDMStaging)].dbo.ProjectionTerritoryTree_lu region ON region.Id = tree.ProjectionRegionId
	JOIN [$(MediaDMStaging)].dbo.Territory_lu r ON r.Id = Region.TerritoryId
) tt;


MERGE 
    dbo.DimProjectionTerritory t
USING 
    #DimProjectionTerritory s ON (t.ProjectionTerritoryKey = s.ProjectionTerritoryKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.ProjectionTerritoryKey = s.ProjectionTerritoryKey, 
		t.SourceTerritoryId = s.SourceTerritoryId, 
		t.TerritoryRegion = s.TerritoryRegion, 
		t.TerritoryName = s.TerritoryName,
		t.TerritoryTreeId = s.TerritoryTreeId, 
		t.TerritoryTreeParentId = s.TerritoryTreeParentId,
		t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProjectionTerritoryKey, SourceTerritoryId, TerritoryRegion, TerritoryName, TerritoryTreeId, TerritoryTreeParentId, HashKey)
    VALUES (s.ProjectionTerritoryKey, s.SourceTerritoryId, s.TerritoryRegion, s.TerritoryName, s.TerritoryTreeId, s.TerritoryTreeParentId , s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimProjectionTerritory] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimProjectionTerritory] TO [DataServices]
    AS [dbo];
GO

