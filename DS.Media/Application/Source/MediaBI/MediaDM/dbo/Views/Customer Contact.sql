
CREATE VIEW [dbo].[Customer Contact]
AS SELECT
	CustomerContactKey AS [Customer Contact Key]
	,CustomerNo AS [Customer No]
	,CustomerName AS [Customer Name]
	,CustomerShortName AS [Customer Short Name]
	,ContactName AS [Contact Name]
	,ProjectionTerritory AS [Projection Territory]
	,[SAPCustomerNumber] AS [SAP Customer Number]
	,[SAPPayerNumber] AS [SAP Payer Number]
	,[SOLId] AS [SOL ID]
	,[RightsSelection] AS [Rights Selection]
	,[TerritorySelection] AS [Territory Selection]
	,[LanguageSelection] AS [Language Selection]
	,[NumberOfTransmissions] AS [Number Of Transmissions]
	,[NumberOfTransmissionsName] AS [Number Of Transmissions Name]
	,(SELECT CASE WHEN COALESCE(MAX(dd.FirstProcessedDate),'19000101') = '19000101' THEN -1
			      ELSE DATEDIFF(DAY,MAX(dd.FirstProcessedDate), GETDATE()) 
			 END AS DaysDeal
	    FROM dbo.DimCustomerContact dcc1
	    LEFT JOIN FactAllocations fa on dcc1.CustomerContactKey = fa.CustomerContactKey
	    LEFT JOIN DimDeal dd on dd.DealKey = fa.DealKey 
		WHERE DealStatus = 'Processed' AND dcc1.CustomerNo = dcc.CustomerNo AND dcc1.CustomerName = dcc.CustomerName)   
	 AS [Days Since Last Deal]
	,(SELECT CASE WHEN COALESCE(max(di.InvoiceDueDate),'19000101') = '19000101' THEN -1
				  WHEN MAX(di.InvoiceDueDate) > GETDATE() THEN 0
	              ELSE DATEDIFF(day,max(di.InvoiceDueDate),GETDATE()) 
			 END AS DaysInvoicing 
	    FROM dbo.DimCustomerContact dcc1
	    LEFT JOIN FactAllocations fa on dcc1.CustomerContactKey = fa.CustomerContactKey
	    LEFT JOIN DimInvoicing di on di.InvoicingKey = fa.InvoicingKey
		WHERE InvoiceStatus ='Cleared' AND CancellationStatus = 'Not Cancelled' AND dcc1.CustomerNo = dcc.CustomerNo AND dcc1.CustomerName = dcc.CustomerName)   
	 AS [Days Since Last Invoicing]
FROM dbo.DimCustomerContact dcc

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Customer Contact] TO [DataServices]
    AS [dbo];

