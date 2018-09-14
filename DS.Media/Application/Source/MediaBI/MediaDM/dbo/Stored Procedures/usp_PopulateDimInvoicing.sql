
CREATE PROCEDURE [dbo].[usp_PopulateDimInvoicing]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimInvoicing') IS NOT NULL DROP TABLE #DimInvoicing

SELECT * INTO #DimInvoicing FROM dbo.DimInvoicing WHERE 1 = 2;

CREATE CLUSTERED INDEX IC_InvoicingInvoicingKey ON #DimInvoicing(InvoicingKey);


-- Prepare data to temp table - Accounting Document Number
IF OBJECT_ID('tempdb..#SAPImportedInvoices') IS NOT NULL drop table #SAPImportedInvoices

Select DISTINCT 
	[SOL_NUMBER]
	,[SAP_INVOICE]
	,[SAP_ACCTG_DOC]
	,[SAP_CLEAR_DOC]
	,[SAP_CLEAR_DATE]
	,[SAP_INV_DATE]
	,[SAP_INV_DATE_FIRST]
	,[InvoiceId] 
	,[InvoiceType]
	,[SAP_BILLING_STATUS]
	INTO #SAPImportedInvoices
FROM
(
	SELECT 
		[SOL_NUMBER]
		,[SAP_INVOICE]
		,[SAP_ACCTG_DOC]
		,CASE WHEN [SAP_CLEAR_DOC] = '' THEN NULL ELSE [SAP_CLEAR_DOC] END AS [SAP_CLEAR_DOC]
		,TRY_CAST ([SAP_CLEAR_DATE] AS DATE) AS [SAP_CLEAR_DATE]
		,TRY_CAST([SAP_INV_DATE] AS DATE) AS [SAP_INV_DATE]
		,FIRST_VALUE(TRY_CAST([SAP_INV_DATE] AS DATE)) OVER (PARTITION BY [SAP_INVOICE], [InvoiceId] ORDER BY [UpdatedDate]) AS [SAP_INV_DATE_FIRST]
		,[InvoiceId]
		,[InvoiceType]
		,LOWER([SAP_BILLING_STATUS]) AS [SAP_BILLING_STATUS]
		,ROW_NUMBER() OVER (PARTITION BY [InvoiceId],[SAP_INVOICE] ORDER BY [UpdatedDate] DESC) AS RowNumber
	FROM [$(MediaDMStaging)].[dbo].[SAPImportedInvoices]
	WHERE StatusId = 1
) as t
WHERE RowNumber = 1



INSERT INTO #DimInvoicing 
SELECT
  InvoicingKey
	,SOLItem
	,BillingCode
	,InvoiceCategory
	,InvoiceStatus
	,InterfaceStatus
	,FeeType
	,OrderHeaderId
	,OrderDetailId
	,InstallmentNo
	,CurrencyCode
	,ProjectionYear
	,SAPLineItemNumber
	,SAPSalesOrderNumber
	,InvoiceDueDate
	,SAPInvoiceCreatedDate
	,SAPDocumentDate
	,InvoiceUpdatedDate
	,InvoiceInstructions
	,InvoiceDescription
	,InvoiceReferenceNumber
	,RightsTechIndicator
	,CancellationStatus
	,City
	,Region
	,Country
	,AccountingDocumentNumber
	,ClearingDocumentNumber
	,ClearingDocumentDate
	,SOLNumber
	,SAP_BILLING_STATUS
	,IsDataMartDueDate
	,IssueSite
	,BillingCompanyId
	,BillingCompany
    ,dbo.ufn_GetHashDimInvoicing( InvoicingKey, SOLItem, BillingCode, InvoiceCategory, InvoiceStatus, InterfaceStatus, FeeType, OrderHeaderId, OrderDetailId, InstallmentNo
		,CurrencyCode, ProjectionYear, SAPLineItemNumber, SAPSalesOrderNumber, InvoiceDueDate, SAPInvoiceCreatedDate, SAPDocumentDate, InvoiceUpdatedDate, InvoiceInstructions
		,InvoiceDescription, InvoiceReferenceNumber, RightsTechIndicator, CancellationStatus, City, Region, Country, AccountingDocumentNumber, ClearingDocumentNumber
		,ClearingDocumentDate, SOLNumber, SAP_BILLING_STATUS, IsDataMartDueDate, IssueSite, BillingCompanyId, BillingCompany) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID('R' + CONVERT(VARCHAR(10), r.Id)) as InvoicingKey
	, r.Id AS SOLItem
	, CASE ri.BillingCodeId
		WHEN 1 THEN 'Unknown'
		WHEN 2 THEN 'Known'
		WHEN 3 THEN 'No Charge'
	END as BillingCode
	, CASE ri.InvoiceCategoryId
		WHEN 1 THEN 'Invoice'
		WHEN 2 THEN 'Invoice Advice'
	END as InvoiceCategory
	, s.Description as InvoiceStatus
	, CASE ri.CommsInterfaceStatusId
		WHEN 0 THEN 'Not Interfaced'
		WHEN 1 THEN 'Pending Interface'
		WHEN 2 THEN 'Posted'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Error'
	END as InterfaceStatus
	,f.[Description] as FeeType
	,ri.OrderHeaderId
	,r.OrderDetailId
	,COALESCE(ri.InstallmentNo, -1) as InstallmentNo
	,COALESCE(c.Code, 'N/A') as CurrencyCode
	,COALESCE(r.ProjectionYear, '1900') as ProjectionYear
	,COALESCE(r.SAPLineItemNumber, 'N/A') as SAPLineItemNumber
	,COALESCE(ri.SAPSalesOrderNumber, 'N/A') as SAPSalesOrderNumber
--	,COALESCE(ri.InvoiceDueDate, '1900-01-01') as InvoiceDueDate
--	,COALESCE(sii.SAP_INV_DATE_FIRST, '1900-01-01') AS SAPInvoiceCreatedDate
--	,COALESCE(ri.CreatedDate, '1900-01-01') as SAPDocumentDate
--	,COALESCE(ri.UpdatedDate, '1900-01-01') AS InvoiceUpdatedDate
	,ri.InvoiceDueDate as InvoiceDueDate
	,sii.SAP_INV_DATE_FIRST AS SAPInvoiceCreatedDate
	,ri.CreatedDate as SAPDocumentDate
	,ri.UpdatedDate AS InvoiceUpdatedDate
	,COALESCE(ri.InvoiceInstructions, 'Unknown') as InvoiceInstructions
	,COALESCE(ri.InvoiceDescription, 'Unknown') as InvoiceDescription
	,COALESCE(ri.InvoiceReferenceNumber, 'N/A') as InvoiceReferenceNumber
	,'Rights' as [RightsTechIndicator]
	,CASE 
		WHEN ri.CreditedInvoiceId IS NOT NULL THEN 'Credit Note' 
		WHEN ri.InvoiceWasCancelled = 1 THEN 'Cancelled' 
		ELSE 'Not Cancelled'
	END as CancellationStatus
	,COALESCE(ca.[Line3], 'N/A') AS City
	,COALESCE(tr.[Description], 'N/A') AS Region
	,COALESCE(ti.[Description], 'N/A') AS Country
	,COALESCE(sii.[SAP_ACCTG_DOC], 'N/A') AS AccountingDocumentNumber
	,CASE 
	   WHEN COALESCE(ri.CreatedDate, '1900-01-01') > COALESCE(sii.[SAP_CLEAR_DATE], '1900-01-01') THEN 'N/A'
	   ELSE COALESCE(sii.[SAP_CLEAR_DOC], 'N/A') 
	 END AS ClearingDocumentNumber
	,CASE 
	   WHEN COALESCE(ri.CreatedDate, '1900-01-01') > COALESCE(sii.[SAP_CLEAR_DATE], '1900-01-01') THEN '1900-01-01'
	   ELSE COALESCE(sii.[SAP_CLEAR_DATE], '1900-01-01')
     END AS ClearingDocumentDate
	,COALESCE(sii.[SOL_NUMBER], 'N/A') AS [SOLNumber]
	,COALESCE(sii.[SAP_BILLING_STATUS], 'N/A') AS [SAP_BILLING_STATUS]
	,CASE 
		WHEN ri.IsDataMartDueDate = 1 THEN 'Yes'
		ELSE 'No'
	END AS IsDataMartDueDate
	,COALESCE(isl.[Description],'N/A') AS [IssueSite]
	,COALESCE(bc.[Id],-1) AS [BillingCompanyId]
	,COALESCE(bc.[Description],'Unknown') AS [BillingCompany]
FROM 
	[$(MediaDMStaging)].[dbo].[OrderRightsInvoiceOrderDetail] AS r
	JOIN [$(MediaDMStaging)].[dbo].[OrderRightsInvoice] AS ri
		ON ri.Id = r.OrderRightsInvoiceId
	JOIN [$(MediaDMStaging)].[dbo].[InvoiceStatus_lu] AS s
		ON s.Id = ri.InvoiceStatusId
	JOIN [$(MediaDMStaging)].[dbo].[Fee_lu] AS f
		ON f.Id = ri.RightsFeeId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Currency_lu] AS c
		ON c.Id = ri.CurrencyId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[CustomerAddress] AS ca ON ri.[CustomerAddressId] = ca.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritoryRegion_lu] AS tr ON ca.TerritoryRegionId = tr.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Territory_lu] AS ti ON ca.TerritoryId = ti.[Id]
    INNER JOIN [$(MediaDMStaging)].[dbo].OrderDetail od ON r.OrderDetailId = od.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].BillingCompany_lu bc ON bc.[Id] = od.BillingCompanyId
	LEFT JOIN [$(MediaDMStaging)].[dbo].IssueSite_lu isl ON isl.[Id] = bc.IssueSiteId
	LEFT JOIN #SAPImportedInvoices sii ON r.Id = sii.InvoiceId AND ri.InvoiceReferenceNumber = sii.SAP_INVOICE
WHERE
		r.StatusId = 1
		AND (ri.StatusId = 1 OR ri.StatusId IS NULL)
		AND (sii.InvoiceType = 'R' OR sii.InvoiceType IS NULL)

UNION ALL

SELECT
	dbo.CreateKeyFromSourceID('T' + CONVERT(VARCHAR(10), r.Id)) as InvoicingKey
	, r.Id AS SOLItem
	, CASE ri.BillingCodeId
		WHEN 1 THEN 'Unknown'
		WHEN 2 THEN 'Known'
		WHEN 3 THEN 'No Charge'
	END as BillingCode
	, CASE ri.InvoiceCategoryId
		WHEN 1 THEN 'Invoice'
		WHEN 2 THEN 'Invoice Advice'
	END as InvoiceCategory
	, s.Description as InvoiceStatus
	, CASE ri.CommsInterfaceStatusId
		WHEN 0 THEN 'Not Interfaced'
		WHEN 1 THEN 'Pending Interface'
		WHEN 2 THEN 'Posted'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Error'
	END as InterfaceStatus
	,f.Description as FeeType
	,ri.OrderHeaderId
	,r.OrderDetailId
	,COALESCE(ri.InstallmentNo, -1) as InstallmentNo
	,COALESCE(c.Code, 'N/A') as CurrencyCode
	,COALESCE(r.ProjectionYear, '1900') as ProjectionYear
	,COALESCE(r.SAPLineItemNumber, 'N/A') as SAPLineItemNumber
	,COALESCE(ri.SAPSalesOrderNumber, 'N/A') as SAPSalesOrderNumber
--	,COALESCE(ri.InvoiceDueDate, '1900-01-01') as InvoiceDueDate
--	,COALESCE(sii.SAP_INV_DATE_FIRST, '1900-01-01') AS SAPInvoiceCreatedDate
--	,COALESCE(ri.CreatedDate, '1900-01-01') as SAPDocumentDate
--	,COALESCE(ri.UpdatedDate, '1900-01-01') AS InvoiceUpdatedDate
	,ri.InvoiceDueDate AS InvoiceDueDate
	,sii.SAP_INV_DATE_FIRST AS SAPInvoiceCreatedDate
	,ri.CreatedDate AS SAPDocumentDate
	,ri.UpdatedDate AS InvoiceUpdatedDate
	,COALESCE(ri.InvoiceInstructions, 'Unknown') as InvoiceInstructions
	,COALESCE(ri.InvoiceDescription, 'Unknown') as InvoiceDescription
	,COALESCE(ri.InvoiceReferenceNumber, 'N/A') as InvoiceReferenceNumber
	,'Technical' as [RightsTechIndicator]
	,CASE 
		WHEN ri.CreditedInvoiceId IS NOT NULL THEN 'Credit Note' 
		WHEN ri.InvoiceWasCancelled = 1 THEN 'Cancelled' 
		ELSE 'Not Cancelled'
	END as CancellationStatus
	,COALESCE(ca.[Line3], 'N/A') AS City
	,COALESCE(tr.[Description], 'N/A') AS Region
	,COALESCE(ti.[Description], 'N/A') AS Country
	,COALESCE(sii.[SAP_ACCTG_DOC], 'N/A') AS AccountingDocumentNumber
	,COALESCE(sii.[SAP_CLEAR_DOC], 'N/A') AS ClearingDocumentNumber
--	,COALESCE(sii.[SAP_CLEAR_DATE], '1900-01-01') AS ClearingDocumentDate
	,sii.[SAP_CLEAR_DATE] AS ClearingDocumentDate
	,COALESCE(sii.[SOL_NUMBER], 'N/A') AS [SOLNumber]
	,COALESCE(sii.[SAP_BILLING_STATUS], 'N/A') AS [SAP_BILLING_STATUS]
	,CASE 
		WHEN ri.IsDataMartDueDate = 1 THEN 'Yes'
		ELSE 'No'
	END AS IsDataMartDueDate
	,COALESCE(isl.[Description],'N/A') AS [IssueSite]
	,COALESCE(bc.[Id],-1) AS [BillingCompanyId]
	,COALESCE(bc.[Description],'Unknown') AS [BillingCompany]
FROM 
	[$(MediaDMStaging)].dbo.OrderInvoiceDetail r
	INNER JOIN [$(MediaDMStaging)].dbo.OrderInvoice ri ON ri.Id = r.OrderInvoiceId
	INNER JOIN [$(MediaDMStaging)].dbo.InvoiceStatus_lu s ON s.Id = ri.InvoiceStatusId
	INNER JOIN [$(MediaDMStaging)].dbo.Fee_lu f ON f.Id = ri.FeeId
	LEFT JOIN [$(MediaDMStaging)].dbo.Currency_lu c ON c.Id = ri.CurrencyId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[CustomerAddress] AS ca ON ri.[CustomerAddressId] = ca.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritoryRegion_lu] AS tr ON ca.TerritoryRegionId = tr.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Territory_lu] AS ti ON ca.TerritoryId = ti.[Id]
    INNER JOIN [$(MediaDMStaging)].[dbo].OrderDetail od ON r.OrderDetailId = od.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].BillingCompany_lu bc ON bc.[Id] = od.BillingCompanyId
	LEFT JOIN [$(MediaDMStaging)].[dbo].IssueSite_lu isl ON isl.[Id] = bc.IssueSiteId
	LEFT JOIN #SAPImportedInvoices sii ON r.Id = sii.InvoiceId AND ri.InvoiceReferenceNumber = sii.SAP_INVOICE
WHERE
		r.StatusId = 1
		AND (ri.StatusId = 1 OR ri.StatusId IS NULL)
		AND (sii.InvoiceType = 'T' OR sii.InvoiceType IS NULL)

UNION ALL

SELECT 
	dbo.CreateKeyFromSourceID('R-1') AS InvoicingKey
	,-1 AS SOLItem
	,'N/A' AS BillingCode
	,'N/A' AS InvoiceCategory
	,'N/A' AS InvoiceStatus
	,'N/A' AS InterfaceStatus
	,'N/A' AS FeeType
	,-1 AS OrderHeaderId
	,-1 AS OrderDetailId
	,-1 AS InstallmentNo
	,'N/A' AS CurrencyCode
	,'1900' AS ProjectionYear
	,'N/A' AS SAPLineItemNumber
	,'N/A' AS SAPSalesOrderNumber
	,NULL AS InvoiceDueDate
	,NULL AS SAPInvoiceCreatedDate
	,NULL AS SAPDocumentDate
	,NULL AS InvoiceUpdatedDate
	,'Unknown' AS InvoiceInstructions
	,'Unknown' AS InvoiceDescription
	,'N/A' AS InvoiceReferenceNumber
	,'Rights' AS [RightsTechIndicator]
	,'N/A' AS CancellationStatus
	,'N/A' AS City
	,'N/A' AS Region
	,'N/A' AS Country
	,'N/A' AS AccountingDocumentNumber
	,'N/A' AS ClearingDocumentNumber
	,NULL AS ClearingDocumentDate
	,'N/A' AS [SOLNumber]
	,'N/A' AS [SAP_BILLING_STATUS]
	,'N/A' AS IsDataMartDueDate
	,'N/A' AS [IssueSite]
	,-1 AS [BillingCompanyId]
	,'Unknown' AS [BillingCompany]

UNION ALL

SELECT 
	dbo.CreateKeyFromSourceID('T-1') AS InvoicingKey
	,-1 AS SOLItem
	,'N/A' AS BillingCode
	,'N/A' AS InvoiceCategory
	,'N/A' AS InvoiceStatus
	,'N/A' AS InterfaceStatus
	,'N/A' AS FeeType
	,-1 AS OrderHeaderId
	,-1 AS OrderDetailId
	,-1 AS InstallmentNo
	,'N/A' AS CurrencyCode
	,'1900' AS ProjectionYear
	,'N/A' AS SAPLineItemNumber
	,'N/A' AS SAPSalesOrderNumber
	,'1900-01-01' AS InvoiceDueDate
	,'1900-01-01' AS SAPInvoiceCreatedDate
	,'1900-01-01' AS SAPDocumentDate
	,'1900-01-01' AS InvoiceUpdatedDate
	,'Unknown' AS InvoiceInstructions
	,'Unknown' AS InvoiceDescription
	,'N/A' AS InvoiceReferenceNumber
	,'Technical' AS [RightsTechIndicator]
	,'N/A' AS CancellationStatus
	,'N/A' AS City
	,'N/A' AS Region
	,'N/A' AS Country
	,'N/A' AS AccountingDocumentNumber
	,'N/A' AS ClearingDocumentNumber
	,'1900-01-01' AS ClearingDocumentDate
	,'N/A' AS [SOLNumber]
	,'N/A' AS [SAP_BILLING_STATUS]
	,'N/A' AS IsDataMartDueDate
	,'N/A' AS [IssueSite]
	,-1 AS [BillingCompanyId]
	,'Unknown' AS [BillingCompany]
) tt


MERGE 
    dbo.DimInvoicing t
USING 
    #DimInvoicing s ON (t.InvoicingKey = s.InvoicingKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
	     t.InvoicingKey = s.InvoicingKey
		,t.SOLItem = s.SOLItem
		,t.BillingCode = s.BillingCode
		,t.InvoiceCategory = s.InvoiceCategory
		,t.InvoiceStatus = s.InvoiceStatus
		,t.InterfaceStatus = s.InterfaceStatus
		,t.FeeType = s.FeeType
		,t.OrderHeaderId = s.OrderHeaderId
		,t.OrderDetailId = s.OrderDetailId
		,t.InstallmentNo = s.InstallmentNo
		,t.CurrencyCode = s.CurrencyCode
		,t.ProjectionYear = s.ProjectionYear
		,t.SAPLineItemNumber = s.SAPLineItemNumber
		,t.SAPSalesOrderNumber = s.SAPSalesOrderNumber
		,t.InvoiceDueDate = s.InvoiceDueDate
		,t.SAPInvoiceCreatedDate = s.SAPInvoiceCreatedDate
		,t.SAPDocumentDate = s.SAPDocumentDate
		,t.InvoiceUpdatedDate = s.InvoiceUpdatedDate
		,t.InvoiceInstructions = s.InvoiceInstructions
		,t.InvoiceDescription = s.InvoiceDescription
		,t.InvoiceReferenceNumber = s.InvoiceReferenceNumber
		,t.RightsTechIndicator = s.RightsTechIndicator
		,t.CancellationStatus = s.CancellationStatus
		,t.City = s.City
		,t.Region = s.Region
		,t.Country = s.Country
		,t.AccountingDocumentNumber = s.AccountingDocumentNumber
		,t.ClearingDocumentNumber = s.ClearingDocumentNumber
		,t.ClearingDocumentDate = s.ClearingDocumentDate
		,t.SOLNumber = s.SOLNumber
		,t.SAP_BILLING_STATUS = s.SAP_BILLING_STATUS
		,t.IsDataMartDueDate = s.IsDataMartDueDate
		,t.IssueSite = s.IssueSite
		,t.BillingCompanyId = s.BillingCompanyId
		,t.BillingCompany = s.BillingCompany
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (InvoicingKey, SOLItem, BillingCode, InvoiceCategory, InvoiceStatus, InterfaceStatus, FeeType, OrderHeaderId, OrderDetailId, InstallmentNo
		,CurrencyCode, ProjectionYear, SAPLineItemNumber, SAPSalesOrderNumber, InvoiceDueDate, SAPInvoiceCreatedDate, SAPDocumentDate, InvoiceUpdatedDate, InvoiceInstructions
		,InvoiceDescription, InvoiceReferenceNumber, RightsTechIndicator, CancellationStatus, City, Region, Country, AccountingDocumentNumber, ClearingDocumentNumber
		,ClearingDocumentDate, SOLNumber, SAP_BILLING_STATUS, IsDataMartDueDate, IssueSite, BillingCompanyId, BillingCompany, HashKey)
    VALUES (s.InvoicingKey, s.SOLItem, s.BillingCode, s.InvoiceCategory, s.InvoiceStatus, s.InterfaceStatus, s.FeeType, s.OrderHeaderId, s.OrderDetailId, s.InstallmentNo
		,s.CurrencyCode, s.ProjectionYear, s.SAPLineItemNumber, s.SAPSalesOrderNumber, s.InvoiceDueDate, s.SAPInvoiceCreatedDate, s.SAPDocumentDate, s.InvoiceUpdatedDate, s.InvoiceInstructions
		,s.InvoiceDescription, s.InvoiceReferenceNumber, s.RightsTechIndicator, s.CancellationStatus, s.City, s.Region, s.Country, s.AccountingDocumentNumber, s.ClearingDocumentNumber
		,s.ClearingDocumentDate, s.SOLNumber, s.SAP_BILLING_STATUS, s.IsDataMartDueDate, s.IssueSite, s.BillingCompanyId, s.BillingCompany, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimInvoicing] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimInvoicing] TO [DataServices]
    AS [dbo];
GO
