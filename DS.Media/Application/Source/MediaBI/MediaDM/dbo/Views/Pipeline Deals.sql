

CREATE VIEW  [dbo].[Pipeline Deals]
AS
SELECT [PipelineDealHistoryKey] AS [Pipeline Deal History Key]
	  ,[PipelineDealKey] AS [Pipeline Deal Key]
      ,[DealKey] AS [Deal Key]
      ,[SalesProgress] AS [Sales Progress]
	  ,[ProjectionKey] AS [Projection Key]
	  ,[PropertyKey] AS [Property Key]
	  ,[CustomerContactKey] AS [Customer Contact Key]
	  ,[SalesAreaKey] AS [Sales Area Key]
  FROM [dbo].[FactPipelineDeals]
GO


GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Pipeline Deals] TO [DataServices]
    AS [dbo];
GO
