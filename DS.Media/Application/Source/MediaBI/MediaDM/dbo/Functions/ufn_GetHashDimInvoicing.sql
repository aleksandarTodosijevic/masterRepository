Create FUNCTION [dbo].[ufn_GetHashDimInvoicing]
(
	 @InvoicingKey BIGINT
	,@SOLItem VARCHAR(11)
	,@BillingCode VARCHAR(20)
	,@InvoiceCategory VARCHAR(20)
	,@InvoiceStatus VARCHAR(20)
	,@InterfaceStatus VARCHAR(20)
	,@FeeType VARCHAR(50)
	,@OrderHeaderId INT
	,@OrderDetailId INT
	,@InstallmentNo INT
	,@CurrencyCode CHAR(3)
	,@ProjectionYear CHAR(4)
	,@SAPLineItemNumber VARCHAR(20)
	,@SAPSalesOrderNumber VARCHAR(20)
	,@InvoiceDueDate DATETIME
	,@SAPInvoiceCreatedDate DATETIME
	,@SAPDocumentDate DATETIME
	,@InvoiceUpdatedDate DATETIME
	,@InvoiceInstructions VARCHAR(2048)
	,@InvoiceDescription VARCHAR(2048)
	,@InvoiceRefferenceNumber VARCHAR(20)
	,@RightsTechIndicator VARCHAR(10)
	,@CancellationStatus VARCHAR(13)
	,@City VARCHAR(50)
	,@Region VARCHAR(50)
	,@Country VARCHAR(50)
	,@AccountingDocumentNumber VARCHAR(10)
	,@ClearingDocumentNumber VARCHAR(20)
	,@ClearingDocumentDate DATE
	,@SOLNumber VARCHAR(10)
	,@SAP_BILLING_STATUS VARCHAR(20)
	,@IsDataMartDueDate CHAR(3)
	,@IssueSite VARCHAR(50)
	,@BillingCompanyId INT
	,@BillingCompany VARCHAR(80)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @InvoicingKey AS InvoicingKey
	,@SOLItem AS SOLItem
	,@BillingCode AS BillingCode
	,@InvoiceCategory AS InvoiceCategory
	,@InvoiceStatus AS InvoiceStatus
	,@InterfaceStatus AS InterfaceStatus
	,@FeeType AS FeeType
	,@OrderHeaderId AS OrderHeaderId
	,@OrderDetailId AS OrderDetailId
	,@InstallmentNo AS InstallmentNo
	,@CurrencyCode AS CurrencyCode
	,@ProjectionYear AS ProjectionYear
	,@SAPLineItemNumber AS SAPLineItemNumber
	,@SAPSalesOrderNumber AS SAPSalesOrderNumber
	,@InvoiceDueDate AS InvoiceDueDate
	,@SAPInvoiceCreatedDate AS SAPInvoiceCreatedDate
	,@SAPDocumentDate AS SAPDocumentDate
	,@InvoiceUpdatedDate AS InvoiceUpdatedDate
	,@InvoiceInstructions AS InvoiceInstructions
	,@InvoiceDescription AS InvoiceDescription
	,@InvoiceRefferenceNumber AS InvoiceRefferenceNumber
	,@RightsTechIndicator AS RightsTechIndicator
	,@CancellationStatus AS CancellationStatus
	,@City AS City
	,@Region AS Region
	,@Country AS Country
	,@AccountingDocumentNumber AS AccountingDocumentNumber
	,@ClearingDocumentNumber AS ClearingDocumentNumber
	,@ClearingDocumentDate AS ClearingDocumentDate
	,@SOLNumber AS SOLNumber
	,@SAP_BILLING_STATUS AS SAP_BILLING_STATUS
	,@IsDataMartDueDate AS IsDataMartDueDate
	,@IssueSite AS IssueSite
	,@BillingCompanyId AS BillingCompanyId
	,@BillingCompany AS BillingCompany
	FOR XML RAW('r')))
END