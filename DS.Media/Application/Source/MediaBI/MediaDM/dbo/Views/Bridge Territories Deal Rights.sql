CREATE VIEW [dbo].[Bridge Territories Deal Rights]
AS

SELECT [TerritoryTreeKey] AS [Territory Tree Key]
      ,[DealRightsKey] AS [Deal Rights Key]
  FROM [dbo].[FactBridgeTerritoriesDealRights]
GO

