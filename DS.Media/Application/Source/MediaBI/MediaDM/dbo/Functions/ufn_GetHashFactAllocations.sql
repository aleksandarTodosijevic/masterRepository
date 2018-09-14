CREATE FUNCTION [dbo].[ufn_GetHashFactAllocations]
(    @DealCreatedByKey BIGINT
	,@DealUpdatedByKey BIGINT
	,@DealCreatedOnDateKey INT
	,@DealUpdatedOnDateKey INT
	,@InvoiceCreatedOnDateKey INT
	,@InvoiceProcessedDateKey INT
	,@DueDateKey INT
	,@ShipDateKey INT
	,@AllocationCreatedDateKey INT
    ,@AllocationUpdatedDateKey INT
	,@DMDateKey INT
	,@LicenseStartDateKey INT
	,@LicenseEndDateKey INT
	,@EntertainmentShippedDateKey INT
	,@RecognitionDateKey INT
	,@ActualAmount MONEY
	,@ActualAmountUSD MONEY
	,@CountOfAllocation BIT
	,@ProjectionYear CHAR(4)
	,@SalesAreaKey BIGINT
	,@IncomeTypeKey BIGINT
	,@PropertyKey BIGINT
	,@ProjectionKey BIGINT
	,@CustomerContactKey BIGINT
	,@ProjectionTerritoryKey BIGINT
	,@CurrencyKey BIGINT
	,@DealKey BIGINT
	,@InvoicingKey BIGINT
	,@DealPropertyKey BIGINT
	,@DeliveryKey BIGINT
	,@PipelineDealKey BIGINT
	,@ContractKey BIGINT
	,@BillingCode CHAR(9)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @DealCreatedByKey AS DealCreatedByKey
	,@DealUpdatedByKey AS DealUpdatedByKey
	,@DealCreatedOnDateKey AS DealCreatedOnDateKey
	,@DealUpdatedOnDateKey AS DealUpdatedOnDateKey
	,@InvoiceCreatedOnDateKey AS InvoiceCreatedOnDateKey
	,@InvoiceProcessedDateKey AS InvoiceProcessedDateKey
	,@DueDateKey AS DueDateKey
	,@ShipDateKey AS ShipDateKey
	,@AllocationCreatedDateKey AS AllocationCreatedDateKey
    ,@AllocationUpdatedDateKey AS AllocationUpdatedDateKey
	,@DMDateKey AS DMDateKey
	,@LicenseStartDateKey AS LicenseStartDateKey
	,@LicenseEndDateKey AS LicenseEndDateKey
	,@EntertainmentShippedDateKey AS EntertainmentShippedDateKey
	,@RecognitionDateKey AS RecognitionDateKey
	,@ActualAmount AS ActualAmount
	,@ActualAmountUSD AS ActualAmountUSD
	,@CountOfAllocation AS CountOfAllocation
	,@ProjectionYear AS ProjectionYear
	,@SalesAreaKey AS SalesAreaKey
	,@IncomeTypeKey AS IncomeTypeKey
	,@PropertyKey AS PropertyKey
	,@ProjectionKey AS ProjectionKey
	,@CustomerContactKey AS CustomerContactKey
	,@ProjectionTerritoryKey AS ProjectionTerritoryKey
	,@CurrencyKey AS CurrencyKey
	,@DealKey AS DealKey
	,@InvoicingKey AS InvoicingKey
	,@DealPropertyKey AS DealPropertyKey
	,@DeliveryKey AS DeliveryKey
	,@PipelineDealKey AS PipelineDealKey
	,@ContractKey AS ContractKey
	,@BillingCode AS BillingCode
	FOR XML RAW('r')))
END