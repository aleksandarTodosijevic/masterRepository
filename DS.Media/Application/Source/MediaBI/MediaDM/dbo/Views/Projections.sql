

CREATE VIEW [dbo].[Projections]
AS SELECT
	ProjectionYear 
	,SalesAreaKey 
	,IncomeTypeKey 
	,PropertyKey 
	,CustomerContactKey 
	,ProjectionTerritoryKey
	,CurrencyKey
	,ProjectionKey
	,ProjectionAnticipatedKey
	,PipelineDealKey
	,AnticipatedAmount
	,AnticipatedAmountUSD 
	,ActualAmount 
	,ActualAmountUSD 
	,TargetAmount
	,TargetAmountUSD
	,SalesProgress
FROM dbo.FactProjections
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Projections] TO [DataServices]
    AS [dbo];
GO