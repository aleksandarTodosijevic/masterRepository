CREATE VIEW [dbo].[Projection Territory]
AS SELECT
	[ProjectionTerritoryKey]
	,[SourceTerritoryId]
	,[TerritoryRegion] as [Territory Region]
	,[TerritoryName] as [Territory Name]
	,[TerritoryTreeId] AS [Territory Tree Id]
	,[TerritoryTreeParentId] AS [Territory TreeParent Id]
FROM [dbo].[DimProjectionTerritory]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Projection Territory] TO [DataServices]
    AS [dbo];

