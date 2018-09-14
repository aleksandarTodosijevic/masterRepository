CREATE VIEW [dbo].[Territory]
	AS

SELECT [TerritoryTreeKey] AS [Territory Tree Key]
      ,[TerritoryTreeId] AS [Territory Tree Id]
      ,[TerritoryTreeParentId] AS [Territory Tree Parent Id]
      ,[TerritoryName] AS [Territory Name]
  FROM [dbo].[DimTerritory]


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Territory] TO [DataServices]
    AS [dbo];