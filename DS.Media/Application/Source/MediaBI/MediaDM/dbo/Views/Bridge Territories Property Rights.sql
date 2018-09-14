CREATE VIEW [dbo].[Bridge Territories Property Rights]
AS

SELECT [TerritoryTreeKey] AS [Territory Tree Key]
      ,[PropertyRightsKey] AS [Property Rights Key]
  FROM [dbo].[FactBridgeTerritoriesPropertyRights]
GO

