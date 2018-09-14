

CREATE VIEW [dbo].[Allocations]
AS SELECT
	AllocationsKey
	,ProjectionYear
	,SalesAreaKey
	,IncomeTypeKey
	,PropertyKey
	,CustomerContactKey
	,ProjectionTerritoryKey
	,CurrencyKey
	,DealKey
	,InvoicingKey
	,DealPropertyKey
	,DealCreatedByKey
	,DealUpdatedByKey
	,DealCreatedOnDateKey
	,DealUpdatedOnDateKey
	,InvoiceCreatedOnDateKey
	,InvoiceProcessedDateKey
	,DueDateKey
	,ShipDateKey
	,AllocationCreatedDateKey
	,AllocationUpdatedDateKey
	,ProjectionKey
	,DeliveryKey 
	,DMDateKey
	,LicenseStartDateKey
	,LicenseEndDateKey
	,EntertainmentShippedDateKey
	,RecognitionDateKey
	,PipelineDealKey
	,ContractKey
	,BillingCode AS [Billing Code]
	,ActualAmount
	,ActualAmountUSD
	,CountOfAllocation
FROM dbo.FactAllocations
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Allocations] TO [DataServices]
    AS [dbo];

