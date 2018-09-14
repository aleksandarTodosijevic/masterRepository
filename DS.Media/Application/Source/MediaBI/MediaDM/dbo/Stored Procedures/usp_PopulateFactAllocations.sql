CREATE PROCEDURE [dbo].[usp_PopulateFactAllocations]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactAllocations') IS NOT NULL DROP TABLE #FactAllocations

SELECT * INTO #FactAllocations FROM dbo.FactAllocations WHERE 1 = 2;


---- order detail delivery get list by invoice ---------------------
IF OBJECT_ID('tempdb..#orderDetailDelivery') IS NOT NULL
DROP TABLE #orderDetailDelivery

SELECT 
	OrderDetailDeliveryId,
	OrderInvoiceDetailId,
	ProductId,
	ShipDate,
	Amount,
	COUNT(*) OVER (PARTITION BY OrderInvoiceDetailId, ProductId) AS CountOfProductInvioce
	into #orderDetailDelivery
FROM
(
	SELECT
		odd.Id AS OrderDetailDeliveryId,
		oid.Id AS OrderInvoiceDetailId,
		odd.ProductId AS ProductId,
		odd.ShipDate,
		SUM(oidd.Amount) AS Amount
	FROM
		[$(MediaDMStaging)].dbo.OrderDetailDelivery odd 
		INNER JOIN [$(MediaDMStaging)].dbo.OrderInvoiceDetailDelivery oidd ON oidd.OrderDetailDeliveryId = odd.Id  
		INNER JOIN [$(MediaDMStaging)].dbo.OrderInvoiceDetail oid  ON oid.Id = oidd.OrderInvoiceDetailId 
	WHERE odd.StatusId = 1 AND oidd.StatusId = 1
	GROUP BY odd.Id, oid.Id, odd.ProductId, odd.ShipDate
) AS table1

------------ License End and Start dates -----------------
IF OBJECT_ID('tempdb..#tempLicenseDates') IS NOT NULL
DROP TABLE #tempLicenseDates
Select 
	oh.Id AS DealId
	,rd.OrderDetailId
	,od.ProductId AS ProductId
	,MIN(rd.LicenseStartDate) AS LicenseStartDate
	,MAX(rd.LicenseEndDate) AS LicenseEndDate
	INTO #tempLicenseDates
FROM  [$(MediaDMStaging)].dbo.OrderDetailRightsDetail rd
INNER JOIN  [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = rd.OrderDetailId
INNER JOIN  [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = od.OrderHeaderId
GROUP BY oh.Id, rd.OrderDetailId, od.ProductId

------------ Entertainment Shipped Dates-----------------
DROP TABLE IF EXISTS #tempShippedDates

;WITH CTE_ProductSeries 
AS
(
	SELECT p.Id AS ParentId, p.Id, 0 AS Level
	FROM [$(MediaDMStaging)].[dbo].[Product] p
	WHERE p.ParentId IS NULL
	UNION ALL
	SELECT p.ParentId, p.Id, Level +1
	FROM [$(MediaDMStaging)].[dbo].[Product] p
	INNER JOIN CTE_ProductSeries ps ON p.ParentId = ps.Id
)
SELECT *
INTO #tempShippedDates
FROM (
	SELECT 
		odd.OrderHeaderId AS DealId
		,p.Id AS ProductId
		,p.ParentId
		,p.[Level]
		,MIN(odd.ShippedDate) OVER (PARTITION BY odd.OrderHeaderId, p.Id) AS MinShippedDate
		,ROW_NUMBER() OVER (PARTITION BY odd.OrderHeaderId, p.Id ORDER BY p.Id) AS NumberOfRow
	FROM [$(MediaDMStaging)].[dbo].[OrderDetailDelivery] odd 
	INNER JOIN CTE_ProductSeries p ON odd.ProductId = p.Id
	WHERE odd.StatusId = 1  AND p.[Level] = 1
	UNION ALL
		SELECT 
		odd.OrderHeaderId AS DealId
		,h.Id AS ProductId
		,p.ParentId
		,h.[Level]
		,MIN(odd.ShippedDate) OVER (PARTITION BY odd.OrderHeaderId, h.id) AS MinShippedDate
		,ROW_NUMBER() OVER (PARTITION BY odd.OrderHeaderId, h.id ORDER BY h.id) AS NumberOfRow
	FROM [$(MediaDMStaging)].[dbo].[OrderDetailDelivery] odd 
	INNER JOIN CTE_ProductSeries p ON odd.ProductId = p.Id
	INNER JOIN CTE_ProductSeries h ON h.Id = p.ParentId
	WHERE odd.StatusId = 1  AND h.[Level] = 0
) AS t
WHERE 0=0
AND  t.NumberOfRow = 1
CREATE CLUSTERED INDEX CI_ShippedDates ON #tempShippedDates (DealId, ProductId)

-------------- Insert in to fact table -----------------

INSERT INTO #FactAllocations 
   (AllocationsKey, ProjectionYear, SalesAreaKey, IncomeTypeKey, PropertyKey, ProjectionKey, CustomerContactKey, ProjectionTerritoryKey, CurrencyKey, DealKey
    ,InvoicingKey, DealPropertyKey, DealCreatedByKey, DealUpdatedByKey, DealCreatedOnDateKey, DealUpdatedOnDateKey, InvoiceCreatedOnDateKey, InvoiceProcessedDateKey
	,DueDateKey, ShipDateKey, AllocationCreatedDateKey, AllocationUpdatedDateKey, DeliveryKey, DMDateKey, LicenseStartDateKey, LicenseEndDateKey,
	 EntertainmentShippedDateKey, RecognitionDateKey, PipelineDealKey,ContractKey, BillingCode, ActualAmount, ActualAmountUSD, CountOfAllocation, HashKey, DeletedOn)
SELECT 
	 AllocationsKey
	,ProjectionYear
	,SalesAreaKey
	,IncomeTypeKey
	,PropertyKey
	,ProjectionKey
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
	,DeliveryKey
	,DMDateKey
	,LicenseStartDateKey
	,LicenseEndDateKey
	,EntertainmentShippedDateKey
	,RecognitionDateKey
	,PipelineDealKey
	,ContractKey
	,BillingCode
	,ActualAmount
	,ActualAmountUSD
	,CountOfAllocation
	,dbo.ufn_GetHashFactAllocations(DealCreatedByKey, DealUpdatedByKey, DealCreatedOnDateKey, DealUpdatedOnDateKey, InvoiceCreatedOnDateKey, InvoiceProcessedDateKey,
									DueDateKey, ShipDateKey, AllocationCreatedDateKey, AllocationUpdatedDateKey, DMDateKey, LicenseStartDateKey, LicenseEndDateKey,
									EntertainmentShippedDateKey ,RecognitionDateKey, ActualAmount, ActualAmountUSD, CountOfAllocation, ProjectionYear, SalesAreaKey, 
									IncomeTypeKey, PropertyKey, ProjectionKey, CustomerContactKey, ProjectionTerritoryKey, CurrencyKey, DealKey, InvoicingKey, 
									DealPropertyKey, DeliveryKey, PipelineDealKey,ContractKey,BillingCode) AS HashKey
    ,NULL AS DeletedOn
FROM (
	SELECT 
		 dbo.CreateKeyFromSourceID(CAST(p.Id AS VARCHAR(10)) + CAST(-1 AS VARCHAR(10))) AS AllocationsKey
		,p.ProjectionYear
		,dbo.CreateKeyFromSourceID(oh.SalesAreaId) AS SalesAreaKey
		,dbo.CreateKeyFromSourceID(p.IncomeTypeId) AS IncomeTypeKey
		,dbo.CreateKeyFromSourceID(p.ProductId) AS PropertyKey
		,dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
		,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), ISNULL(oh.CustomerId, -1))
			+':'+ CONVERT(VARCHAR(10), ISNULL(cc.Id, -1))
			+':'+CONVERT(VARCHAR(10), ISNULL(i.CustomerAddressId, -1))
		 ) AS CustomerContactKey
		,dbo.CreateKeyFromSourceID(p.TerritoryId) AS ProjectionTerritoryKey
		,dbo.CreateKeyFromSourceID(p.CurrencyId) AS CurrencyKey
		,dbo.CreateKeyFromSourceID(oh.Id) AS DealKey
		,CASE 
			WHEN p.OriginalFeeTypeId = 1 THEN 
				dbo.CreateKeyFromSourceID('R'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			WHEN p.OriginalFeeTypeId = 2 THEN 
				dbo.CreateKeyFromSourceID('T'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			END AS InvoicingKey
		,dbo.CreateKeyFromSourceID(ISNULL(id.OrderDetailId, -1)) AS DealPropertyKey
		,dbo.CreateKeyFromSourceID(oh.CreatedBy) AS DealCreatedByKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.UpdatedBy, oh.CreatedBy)) AS DealUpdatedByKey
		,dbo.CreateKeyFromDate(oh.CreatedDate) AS DealCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(oh.UpdatedDate, oh.CreatedDate)) AS DealUpdatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.CreatedDate, '1900-01-01')) AS InvoiceCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.InvoiceProcessedDate, '1900-01-01')) AS InvoiceProcessedDateKey
		,dbo.CreateKeyFromDate(p.InvoiceDueDate) AS DueDateKey
--		,dbo.CreateKeyFromDate('1900-01-01') AS ShipDateKey
		,dbo.CreateKeyFromDate(COALESCE((SELECT MAX(ShipDate) FROM [$(MediaDMStaging)].dbo.OrderDetailDelivery odx WHERE odx.OrderHeaderId = oh.Id AND odx.ProductId = pr.Id AND odx.StatusId = 1),'1900-01-01'))  AS ShipDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.CreatedDate,'1900-01-01')) AS AllocationCreatedDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.UpdatedDate,'1900-01-01')) AS AllocationUpdatedDateKey
		,dbo.CreateKeyFromSourceID('-1') AS DeliveryKey
		,dbo.CreateKeyFromDate(IsNull(i.InvoiceDueDate,'1900-01-01')) AS DMDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseStartDate,'1900-01-01')) AS LicenseStartDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseEndDate,'1900-01-01')) AS LicenseEndDateKey
		,dbo.CreateKeyFromDate(ISNULL(tsd.MinShippedDate,'1900-01-01')) AS EntertainmentShippedDateKey
		--,dbo.CreateKeyFromDate(ISNULL('1900-01-01','1900-01-01')) AS RecognitionDateKey
		,dbo.CreateKeyFromDate(ISNULL(
			(SELECT MAX(x) FROM (VALUES (tl.LicenseStartDate),(tsd.MinShippedDate)) AS value(x))
			,'1900-01-01')) AS RecognitionDateKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.SourcePipelineDealId,-1)) AS PipelineDealKey
		,dbo.CreateKeyFromSourceID(ISNULL(od.ContractId,-1)) as ContractKey
		,CASE i.BillingCodeId
			WHEN 1 THEN 'Unknown'
			WHEN 2 THEN 'Known'
			WHEN 3 THEN 'No Charge'
		END as BillingCode
		,p.Amount AS ActualAmount
		,p.USDollarEquivalent AS ActualAmountUSD
		,CASE WHEN p.Id IS NULL THEN 0 ELSE 1 END AS CountOfAllocation
	FROM [$(MediaDMStaging)].dbo.InternalAllocation p 
	INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = p.OrderHeaderId
	LEFT JOIN [$(MediaDMStaging)].dbo.Product pr ON p.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderRightsInvoiceOrderDetail id ON id.Id = p.OrderInvoiceId 
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderRightsInvoice i ON i.Id = id.OrderRightsInvoiceId
	LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.CustomerId = oh.CustomerId AND cc.Id = i.CustomerContactId
	LEFT JOIN #tempLicenseDates tl ON oh.Id = tl.DealId AND p.ProductId = tl.ProductId
	LEFT JOIN #tempShippedDates tsd ON oh.Id = tsd.DealId AND p.ProductId = tsd.ProductId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = id.OrderDetailId
	WHERE p.StatusId = 1 AND oh.OrderStatusId <> 1 AND p.FeeTypeId = 1 AND 
		--i.BillingCodeId <> 3  AND 
		IsDataMartDueDate = 1

	UNION ALL

	SELECT 
		 dbo.CreateKeyFromSourceID(CAST(p.Id AS VARCHAR(10)) + CAST(-1 AS VARCHAR(10))) AS AllocationsKey
		,p.ProjectionYear
		,dbo.CreateKeyFromSourceID(oh.SalesAreaId) AS SalesAreaKey
		,dbo.CreateKeyFromSourceID(p.IncomeTypeId) AS IncomeTypeKey
		,dbo.CreateKeyFromSourceID(p.ProductId) AS PropertyKey
		,dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
		,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), ISNULL(oh.CustomerId, -1))
			+':'+ CONVERT(VARCHAR(10), ISNULL(cc.Id, -1))
			+':'+CONVERT(VARCHAR(10), ISNULL(i.CustomerAddressId, -1))
		 ) AS CustomerContactKey
		,dbo.CreateKeyFromSourceID(p.TerritoryId) AS ProjectionTerritoryKey
		,dbo.CreateKeyFromSourceID(p.CurrencyId) AS CurrencyKey
		,dbo.CreateKeyFromSourceID(oh.Id) AS DealKey
		,CASE 
			WHEN p.OriginalFeeTypeId = 1 THEN 
				dbo.CreateKeyFromSourceID('R'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			WHEN p.OriginalFeeTypeId = 2 THEN 
				dbo.CreateKeyFromSourceID('T'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			END AS InvoicingKey
		,dbo.CreateKeyFromSourceID(ISNULL(id.OrderDetailId, -1)) AS DealPropertyKey
		,dbo.CreateKeyFromSourceID(oh.CreatedBy) AS DealCreatedByKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.UpdatedBy, oh.CreatedBy)) AS DealUpdatedByKey
		,dbo.CreateKeyFromDate(oh.CreatedDate) AS DealCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(oh.UpdatedDate, oh.CreatedDate)) AS DealUpdatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.CreatedDate, '1900-01-01')) AS InvoiceCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.InvoiceProcessedDate, '1900-01-01')) AS InvoiceProcessedDateKey
		,dbo.CreateKeyFromDate(p.InvoiceDueDate) AS DueDateKey
--		,dbo.CreateKeyFromDate('1900-01-01') AS ShipDateKey
		,dbo.CreateKeyFromDate(COALESCE((SELECT MAX(ShipDate) FROM [$(MediaDMStaging)].dbo.OrderDetailDelivery odx WHERE odx.OrderHeaderId = oh.Id AND odx.ProductId = pr.Id AND odx.StatusId = 1),'1900-01-01'))  AS ShipDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.CreatedDate,'1900-01-01')) AS AllocationCreatedDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.UpdatedDate,'1900-01-01')) AS AllocationUpdatedDateKey
		,dbo.CreateKeyFromSourceID('-1') AS DeliveryKey
		,dbo.CreateKeyFromDate(COALESCE(i.InvoiceProcessedDate, '1900-01-01')) AS DMDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseStartDate,'1900-01-01')) AS LicenseStartDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseEndDate,'1900-01-01')) AS LicenseEndDateKey
		,dbo.CreateKeyFromDate(ISNULL(tsd.MinShippedDate,'1900-01-01')) AS EntertainmentShippedDateKey
		,dbo.CreateKeyFromDate(ISNULL(
			(SELECT MAX(x) FROM (VALUES (tl.LicenseStartDate),(tsd.MinShippedDate)) AS value(x))
			,'1900-01-01')) AS RecognitionDateKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.SourcePipelineDealId,-1)) AS PipelineDealKey
		,dbo.CreateKeyFromSourceID(ISNULL(od.ContractId,-1)) as ContractKey
		,CASE i.BillingCodeId
			WHEN 1 THEN 'Unknown'
			WHEN 2 THEN 'Known'
			WHEN 3 THEN 'No Charge'
		END as BillingCode
		,p.Amount AS ActualAmount
		,p.USDollarEquivalent AS ActualAmountUSD
		,CASE WHEN p.Id IS NULL THEN 0 ELSE 1 END AS CountOfAllocation
	FROM [$(MediaDMStaging)].dbo.InternalAllocation p 
	INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = p.OrderHeaderId
	LEFT JOIN [$(MediaDMStaging)].dbo.Product pr ON p.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderRightsInvoiceOrderDetail id ON id.Id = p.OrderInvoiceId 
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderRightsInvoice i ON i.Id = id.OrderRightsInvoiceId
	LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.CustomerId = oh.CustomerId AND cc.Id = i.CustomerContactId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = id.OrderDetailId
	LEFT JOIN #tempLicenseDates tl ON oh.Id = tl.DealId AND p.ProductId = tl.ProductId
	LEFT JOIN #tempShippedDates tsd ON oh.Id = tsd.DealId AND p.ProductId = tsd.ProductId
	WHERE p.StatusId = 1 AND oh.OrderStatusId <> 1 AND p.FeeTypeId = 1 AND 
		--i.BillingCodeId <> 3 AND 
		IsDataMartDueDate != 1

	UNION ALL

	SELECT 
		 dbo.CreateKeyFromSourceID(CAST(p.Id AS VARCHAR(10)) + CAST(COALESCE(odd.OrderDetailDeliveryId, '-1') AS VARCHAR(10))) AS AllocationsKey
		,p.ProjectionYear
		,dbo.CreateKeyFromSourceID(oh.SalesAreaId) AS SalesAreaKey
		,dbo.CreateKeyFromSourceID(p.IncomeTypeId) AS IncomeTypeKey
		,dbo.CreateKeyFromSourceID(p.ProductId) AS PropertyKey
		,dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
		,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), ISNULL(oh.CustomerId, -1))
			+':'+CONVERT(VARCHAR(10), ISNULL(cc.Id, -1))
			+':'+CONVERT(VARCHAR(10), ISNULL(i.CustomerAddressId, -1))
		 ) AS CustomerContactKey
		,dbo.CreateKeyFromSourceID(p.TerritoryId) AS ProjectionTerritoryKey
		,dbo.CreateKeyFromSourceID(p.CurrencyId) AS CurrencyKey
		,dbo.CreateKeyFromSourceID(oh.Id) AS DealKey
		,CASE 
			WHEN p.OriginalFeeTypeId = 1 THEN 
				dbo.CreateKeyFromSourceID('R'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			WHEN p.OriginalFeeTypeId = 2 THEN 
				dbo.CreateKeyFromSourceID('T'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			END AS InvoicingKey
		,dbo.CreateKeyFromSourceID(ISNULL(id.OrderDetailId, -1)) AS DealPropertyKey
		,dbo.CreateKeyFromSourceID(oh.CreatedBy) AS DealCreatedByKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.UpdatedBy, oh.CreatedBy)) AS DealUpdatedByKey
		,dbo.CreateKeyFromDate(oh.CreatedDate) AS DealCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(oh.UpdatedDate, oh.CreatedDate)) AS DealUpdatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.CreatedDate, '1900-01-01')) AS InvoiceCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.InvoiceProcessedDate, '1900-01-01')) AS InvoiceProcessedDateKey
		,dbo.CreateKeyFromDate(p.InvoiceDueDate) AS DueDateKey
		,dbo.CreateKeyFromDate(ISNULL(odd.ShipDate,'1900-01-01')) AS ShipDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.CreatedDate,'1900-01-01')) AS AllocationCreatedDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.UpdatedDate,'1900-01-01')) AS AllocationUpdatedDateKey
		,dbo.CreateKeyFromSourceID(COALESCE(odd.OrderDetailDeliveryId, '-1')) AS DeliveryKey
		,dbo.CreateKeyFromDate(IsNull(i.InvoiceDueDate,'1900-01-01')) AS DMDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseStartDate,'1900-01-01')) AS LicenseStartDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseEndDate,'1900-01-01')) AS LicenseEndDateKey
		,dbo.CreateKeyFromDate(ISNULL(tsd.MinShippedDate,'1900-01-01')) AS EntertainmentShippedDateKey
		,dbo.CreateKeyFromDate(ISNULL(
			(SELECT MAX(x) FROM (VALUES (tl.LicenseStartDate),(tsd.MinShippedDate)) AS value(x))
			,'1900-01-01')) AS RecognitionDateKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.SourcePipelineDealId,-1)) AS PipelineDealKey
		,dbo.CreateKeyFromSourceID(ISNULL(od.ContractId,-1)) as ContractKey
		,CASE i.BillingCodeId
			WHEN 1 THEN 'Unknown'
			WHEN 2 THEN 'Known'
			WHEN 3 THEN 'No Charge'
		END as BillingCode
		,CASE /*If invoice has more deliveries in one property, then allocation is spliting to more rows and amount is taking from Order InvoiceDetail Delivery*/
			WHEN (odd.CountOfProductInvioce IS NULL OR odd.CountOfProductInvioce = 1) THEN p.Amount 
			ELSE odd.Amount
		END AS ActualAmount  
		,CASE 
			WHEN (odd.CountOfProductInvioce IS NULL OR odd.CountOfProductInvioce = 1) THEN p.USDollarEquivalent
			ELSE  odd.Amount * (p.USDollarEquivalent / NULLIF(p.Amount, 0))
		END AS ActualAmountUSD
		,CASE WHEN p.Id IS NULL THEN 0 ELSE 1 END AS CountOfAllocation
	FROM [$(MediaDMStaging)].dbo.InternalAllocation p
	INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = p.OrderHeaderId
	LEFT JOIN [$(MediaDMStaging)].dbo.Product pr ON p.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoiceDetail id ON id.Id = p.OrderInvoiceId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoice i ON i.Id = id.OrderInvoiceId
	LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.CustomerId = oh.CustomerId AND cc.Id = i.CustomerContactId
	LEFT JOIN #orderDetailDelivery odd ON  id.Id = odd.OrderInvoiceDetailId AND p.ProductId = odd.ProductId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = id.OrderDetailId
	LEFT JOIN #tempLicenseDates tl ON oh.Id = tl.DealId AND p.ProductId = tl.ProductId
	LEFT JOIN #tempShippedDates tsd ON oh.Id = tsd.DealId AND p.ProductId = tsd.ProductId
	WHERE p.StatusId = 1 AND oh.OrderStatusId <> 1 AND p.FeeTypeId = 2 AND 
		--i.BillingCodeId <> 3 AND 
		i.IsDataMartDueDate = 1

	UNION ALL

	SELECT 
		 dbo.CreateKeyFromSourceID(CAST(p.Id AS VARCHAR(10)) + CAST(COALESCE(odd.OrderDetailDeliveryId, '-1') AS VARCHAR(10))) AS AllocationsKey
		,p.ProjectionYear
		,dbo.CreateKeyFromSourceID(oh.SalesAreaId) AS SalesAreaKey
		,dbo.CreateKeyFromSourceID(p.IncomeTypeId) AS IncomeTypeKey
		,dbo.CreateKeyFromSourceID(p.ProductId) AS PropertyKey
		,dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
		,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), ISNULL(oh.CustomerId, -1))
			+':'+CONVERT(VARCHAR(10), ISNULL(cc.Id, -1))
			+':'+CONVERT(VARCHAR(10), ISNULL(i.CustomerAddressId, -1))
		 ) AS CustomerContactKey
		,dbo.CreateKeyFromSourceID(p.TerritoryId) AS ProjectionTerritoryKey
		,dbo.CreateKeyFromSourceID(p.CurrencyId) AS CurrencyKey
		,dbo.CreateKeyFromSourceID(oh.Id) AS DealKey
		,CASE 
			WHEN p.OriginalFeeTypeId = 1 THEN 
				dbo.CreateKeyFromSourceID('R'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			WHEN p.OriginalFeeTypeId = 2 THEN 
				dbo.CreateKeyFromSourceID('T'+CONVERT(VARCHAR(10), ISNULL(id.Id, -1)))
			END AS InvoicingKey
		,dbo.CreateKeyFromSourceID(ISNULL(id.OrderDetailId, -1)) AS DealPropertyKey
		,dbo.CreateKeyFromSourceID(oh.CreatedBy) AS DealCreatedByKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.UpdatedBy, oh.CreatedBy)) AS DealUpdatedByKey
		,dbo.CreateKeyFromDate(oh.CreatedDate) AS DealCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(oh.UpdatedDate, oh.CreatedDate)) AS DealUpdatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.CreatedDate, '1900-01-01')) AS InvoiceCreatedOnDateKey
		,dbo.CreateKeyFromDate(ISNULL(i.InvoiceProcessedDate, '1900-01-01')) AS InvoiceProcessedDateKey
		,dbo.CreateKeyFromDate(p.InvoiceDueDate) AS DueDateKey
		,dbo.CreateKeyFromDate(ISNULL(odd.ShipDate,'1900-01-01')) AS ShipDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.CreatedDate,'1900-01-01')) AS AllocationCreatedDateKey
		,dbo.CreateKeyFromDate(ISNULL(p.UpdatedDate,'1900-01-01')) AS AllocationUpdatedDateKey
		,dbo.CreateKeyFromSourceID(COALESCE(odd.OrderDetailDeliveryId, '-1')) AS DeliveryKey
		,dbo.CreateKeyFromDate(COALESCE(i.InvoiceProcessedDate, '1900-01-01')) AS DMDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseStartDate,'1900-01-01')) AS LicenseStartDateKey
		,dbo.CreateKeyFromDate(ISNULL(tl.LicenseEndDate,'1900-01-01')) AS LicenseEndDateKey
		,dbo.CreateKeyFromDate(ISNULL(tsd.MinShippedDate,'1900-01-01')) AS EntertainmentShippedDateKey
		,dbo.CreateKeyFromDate(ISNULL(
			(SELECT MAX(x) FROM (VALUES (tl.LicenseStartDate),(tsd.MinShippedDate)) AS value(x))
			,'1900-01-01')) AS RecognitionDateKey
		,dbo.CreateKeyFromSourceID(ISNULL(oh.SourcePipelineDealId,-1)) AS PipelineDealKey
		,dbo.CreateKeyFromSourceID(ISNULL(od.ContractId,-1)) as ContractKey
		,CASE i.BillingCodeId
			WHEN 1 THEN 'Unknown'
			WHEN 2 THEN 'Known'
			WHEN 3 THEN 'No Charge'
		END as BillingCode
		,CASE /*If invoice has more deliveries in one property, then allocation is spliting to more rows and amount is taking from Order InvoiceDetail Delivery*/
			WHEN (odd.CountOfProductInvioce IS NULL OR odd.CountOfProductInvioce = 1) THEN p.Amount 
			ELSE odd.Amount
		END AS ActualAmount  
		,CASE 
			WHEN (odd.CountOfProductInvioce IS NULL OR odd.CountOfProductInvioce = 1) THEN p.USDollarEquivalent
			ELSE  odd.Amount * (p.USDollarEquivalent / NULLIF(p.Amount, 0))
		END AS ActualAmountUSD
		,CASE WHEN p.Id IS NULL THEN 0 ELSE 1 END AS CountOfAllocation
	FROM [$(MediaDMStaging)].dbo.InternalAllocation p
	INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = p.OrderHeaderId
	LEFT JOIN [$(MediaDMStaging)].dbo.Product pr ON p.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoiceDetail id ON id.Id = p.OrderInvoiceId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoice i ON i.Id = id.OrderInvoiceId
	LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.CustomerId = oh.CustomerId AND cc.Id = i.CustomerContactId
	LEFT JOIN #orderDetailDelivery odd ON  id.Id = odd.OrderInvoiceDetailId AND p.ProductId = odd.ProductId
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = id.OrderDetailId
	LEFT JOIN #tempLicenseDates tl ON oh.Id = tl.DealId AND p.ProductId = tl.ProductId
	LEFT JOIN #tempShippedDates tsd ON oh.Id = tsd.DealId AND p.ProductId = tsd.ProductId
	WHERE p.StatusId = 1 AND oh.OrderStatusId <> 1 AND p.FeeTypeId = 2 AND 
		--i.BillingCodeId <> 3 AND 
		i.IsDataMartDueDate != 1
) tt;

CREATE CLUSTERED INDEX IC_FactAllocationsKey ON #FactAllocations(AllocationsKey)


ALTER TABLE FactAllocations NOCHECK CONSTRAINT all;

MERGE 
    dbo.FactAllocations AS t
USING 
    #FactAllocations AS s ON (
				t.[AllocationsKey] = s.[AllocationsKey]
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
			t.[ProjectionYear] = s.[ProjectionYear]
			,t.[SalesAreaKey] = s.[SalesAreaKey]
			,t.[IncomeTypeKey] = s.[IncomeTypeKey]
			,t.[PropertyKey] = s.[PropertyKey]
			,t.[ProjectionKey] = s.[ProjectionKey]
			,t.[CustomerContactKey] = s.[CustomerContactKey]
			,t.[ProjectionTerritoryKey] = s.[ProjectionTerritoryKey]
			,t.[CurrencyKey] = s.[CurrencyKey]
			,t.[DealKey] = s.[DealKey]
			,t.[InvoicingKey] = s.[InvoicingKey]
			,t.[DealPropertyKey] = s.[DealPropertyKey]
			,t.[DeliveryKey] = s.[DeliveryKey]
			,t.[PipelineDealKey] = s.[PipelineDealKey]
			,t.DealCreatedByKey = s.DealCreatedByKey
			,t.DealUpdatedByKey = s.DealUpdatedByKey
			,t.DealCreatedOnDateKey = s.DealCreatedOnDateKey
			,t.DealUpdatedOnDateKey = s.DealUpdatedOnDateKey
			,t.InvoiceCreatedOnDateKey = s.InvoiceCreatedOnDateKey
			,t.InvoiceProcessedDateKey = s.InvoiceProcessedDateKey
			,t.DueDateKey = s.DueDateKey
			,t.ShipDateKey = s.ShipDateKey
			,t.AllocationCreatedDateKey = s.AllocationCreatedDateKey
			,t.AllocationUpdatedDateKey = s.AllocationUpdatedDateKey
			,t.DMDateKey = s.DMDateKey
			,t.ContractKey = s.ContractKey
			,t.LicenseStartDateKey = s.LicenseStartDateKey
			,t.LicenseEndDateKey = s.LicenseEndDateKey
			,t.EntertainmentShippedDateKey = s.EntertainmentShippedDateKey
			,t.RecognitionDateKey = s.RecognitionDateKey
			,t.ActualAmount = s.ActualAmount
			,t.ActualAmountUSD = s.ActualAmountUSD
			,t.CountOfAllocation = s.CountOfAllocation
			,t.BillingCode = s.BillingCode
			,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ( AllocationsKey, ProjectionYear, SalesAreaKey, IncomeTypeKey, PropertyKey, ProjectionKey, CustomerContactKey, ProjectionTerritoryKey, CurrencyKey, DealKey
    , InvoicingKey, DealPropertyKey, DealCreatedByKey, DealUpdatedByKey, DealCreatedOnDateKey, DealUpdatedOnDateKey, InvoiceCreatedOnDateKey, InvoiceProcessedDateKey
	,DueDateKey, ShipDateKey, AllocationCreatedDateKey, AllocationUpdatedDateKey, DeliveryKey, DMDateKey, LicenseStartDateKey, LicenseEndDateKey,
	EntertainmentShippedDateKey,RecognitionDateKey, PipelineDealKey, ContractKey , BillingCode, ActualAmount, ActualAmountUSD, CountOfAllocation, HashKey)
    VALUES (s.AllocationsKey, s.ProjectionYear, s.SalesAreaKey, s.IncomeTypeKey, s.PropertyKey, s.ProjectionKey, s.CustomerContactKey, s.ProjectionTerritoryKey
	,s.CurrencyKey, s.DealKey, s.InvoicingKey, s.DealPropertyKey, s.DealCreatedByKey, s.DealUpdatedByKey, s.DealCreatedOnDateKey, s.DealUpdatedOnDateKey
	,s.InvoiceCreatedOnDateKey, s.InvoiceProcessedDateKey, s.DueDateKey, s.ShipDateKey, s.AllocationCreatedDateKey, s.AllocationUpdatedDateKey, s.DeliveryKey
	,s.DMDateKey, s.LicenseStartDateKey, s.LicenseEndDateKey, s.EntertainmentShippedDateKey, s.RecognitionDateKey, s.PipelineDealKey, s.ContractKey, s.BillingCode, s.ActualAmount, s.ActualAmountUSD, s.CountOfAllocation, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

ALTER TABLE FactAllocations WITH CHECK CHECK CONSTRAINT ALL;


RETURN 0;

GO

GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactAllocations] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactAllocations] TO [DataServices]
    AS [dbo];
GO