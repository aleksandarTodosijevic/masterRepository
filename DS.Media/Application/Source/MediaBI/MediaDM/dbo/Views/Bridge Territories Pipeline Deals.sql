
CREATE VIEW [dbo].[Bridge Territories Pipeline Deals]
AS

SELECT [TerritoryTreeKey] AS [Territory Tree Key]
      ,[PipelineDealKey] AS [Pipeline Deal Key]
  FROM [dbo].[FactBridgeTerritoriesPipelineDeals]