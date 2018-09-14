/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [Order Details]
AS 
SELECT [ContractKey] AS [Contract Key]
      ,[PropertyKey] AS [Property Key]
      ,[DealPropertyKey] AS [Deal Property Key]
      ,[DealKey] AS [Deal Key]
      ,[CustomerContactKey] AS [Customer Contact Key]
	  ,[DealCreatedByKey] AS [Deal Created By Key]
      ,[DealCreatedOnDateKey] AS [Deal Created On Date Key]
      ,[DealUpdatedByKey] AS [Deal Updated By Key]
      ,[DealUpdatedOnDateKey] AS [Deal Updated On Date Key]
	  ,[ProjectionKey] AS [Projection Key]
  FROM [dbo].[FactOrderDetails]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Order Details] TO [DataServices]
    AS [dbo];

