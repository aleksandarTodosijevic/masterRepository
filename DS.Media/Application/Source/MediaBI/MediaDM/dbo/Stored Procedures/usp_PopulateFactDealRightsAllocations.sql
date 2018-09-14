creAte PROCEDURE [dbo].[usp_PopulateFactDealRightsAllocations]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactDealRightsAllocations') IS NOT NULL DROP TABLE #FactDealRightsAllocations

SELECT * INTO #FactDealRightsAllocations FROM dbo.FactDealRightsAllocations WHERE 1 = 2;


---- order detail delivery get list by invoice ---------------------
IF OBJECT_ID('tempdb..#orderDetailDeliveries') IS NOT NULL
DROP TABLE #orderDetailDeliveries

SELECT 
	OrderDetailDeliveryId,
	OrderInvoiceDetailId,
	ProductId,
	ShipDate,
	Amount,
	COUNT(*) OVER (PARTITION BY OrderInvoiceDetailId, ProductId) AS CountOfProductInvioce
	into #orderDetailDeliveries
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

INSERT INTO #FactDealRightsAllocations 
   ([DealRightsId], [AllocationsKey],  DeletedOn)
SELECT 
	 [DealRightsId]
	,[AllocationsKey]
	--,dbo.ufn_GetHashFactDealRightsAllocations(CountOfDealRightAllocations) AS HashKey
    ,NULL AS DeletedOn
FROM (
Select
	dbo.CreateKeyFromSourceID(rd.Id) AS DealRightsId
	,dbo.CreateKeyFromSourceID(CAST(p.Id AS VARCHAR(10)) + CAST(-1 AS VARCHAR(10))) AS AllocationsKey
	--INTO FactDealRightsAllocations
FROM  [$(MediaDMStaging)].dbo.OrderDetailRightsDetail rd
INNER JOIN [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = rd.OrderDetailId
INNER JOIN [$(MediaDMStaging)].dbo.InternalAllocation p ON p.OrderHeaderId = od.OrderHeaderId AND p.ProductId = od.ProductId
WHERE p.StatusId = 1 AND p.OriginalFeeTypeId = 1 

UNION ALL

Select 
	dbo.CreateKeyFromSourceID(rd.Id) AS DealRightsId
	,dbo.CreateKeyFromSourceID(CAST(p.Id AS VARCHAR(10)) + CAST(COALESCE(odd.OrderDetailDeliveryId, '-1') AS VARCHAR(10))) AS AllocationsKey
FROM  [$(MediaDMStaging)].dbo.OrderDetailRightsDetail rd
INNER JOIN [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = rd.OrderDetailId
INNER JOIN [$(MediaDMStaging)].dbo.InternalAllocation p ON p.OrderHeaderId = od.OrderHeaderId AND p.ProductId = od.ProductId
LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoiceDetail id ON id.Id = p.OrderInvoiceId
LEFT JOIN #orderDetailDeliveries odd ON  id.Id = odd.OrderInvoiceDetailId AND p.ProductId = odd.ProductId
WHERE p.StatusId = 1 AND p.OriginalFeeTypeId = 2 
) tt;


MERGE 
    dbo.FactDealRightsAllocations AS t
USING 
    #FactDealRightsAllocations AS s ON (
				t.[DealRightsId] = s.[DealRightsId]
			AND t.[AllocationsKey] = s.[AllocationsKey]
					 )
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([DealRightsId], [AllocationsKey])
    VALUES (s.[DealRightsId], s.[AllocationsKey])
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;

GO

GO


GO
