CREATE PROCEDURE [dbo].[usp_PopulateDimDeal]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimDeal') IS NOT NULL DROP TABLE #DimDeal
	
SELECT * INTO #DimDeal FROM dbo.DimDeal WHERE 1 = 2;

INSERT INTO #DimDeal 

SELECT
     DealKey
	,DealNo
	,CustomerId
	,SalesAreaId
	,DealStatus
	,SalesCategory
	,FirstProcessedDate
	,LastProcessedDate
    ,dbo.ufn_GetHashDimDeal(DealKey, DealNo, CustomerId, SalesAreaId, DealStatus, SalesCategory, FirstProcessedDate, LastProcessedDate) AS HashKey
    ,NULL AS DeletedOn
FROM (

SELECT
	 dbo.CreateKeyFromSourceID(oh.Id) AS DealKey
	,oh.Id AS DealNo
	,oh.CustomerId AS CustomerId
	,oh.SalesAreaId AS SalesAreaId
	,s.Description AS DealStatus
	,c.Description AS SalesCategory
	,oh.ProcessedDate AS FirstProcessedDate
	,oh.ProcessedDateLast AS LastProcessedDate
FROM [$(MediaDMStaging)].dbo.OrderHeader oh 
JOIN [$(MediaDMStaging)].dbo.OrderStatus_lu s ON s.Id = oh.OrderStatusId
JOIN [$(MediaDMStaging)].dbo.SalesCategory_lu c ON c.Id = oh.SalesCategoryId
WHERE oh.StatusId = 1
UNION ALL
SELECT
	dbo.CreateKeyFromSourceID(-1) AS DealKey
	,-1 AS DealNo
	,-1 AS CustomerId
	,-1 AS SalesAreaId
	,'N/A' AS DealStatus
	,'N/A' AS SalesCategory
	,'1900-01-01' AS FirstProcessedDate
	,'1900-01-01' AS LastProcessedDate
) tt
; 

MERGE 
    dbo.DimDeal t
USING 
    #DimDeal s ON (t.DealKey = s.DealKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.DealKey = s.DealKey
	   ,t.DealNo = s.DealNo
	   ,t.DealStatus = s.DealStatus
	   ,t.CustomerId = s.CustomerId
	   ,t.SalesAreaId = s.SalesAreaId
	   ,t.SalesCategory = s.SalesCategory
	   ,t.FirstProcessedDate = s.FirstProcessedDate
	   ,t.LastProcessedDate = s.LastProcessedDate
	   ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (DealKey, DealNo, DealStatus, CustomerId, SalesAreaId, SalesCategory, FirstProcessedDate, LastProcessedDate, HashKey)
    VALUES (s.DealKey, s.DealNo, s.DealStatus, s.CustomerId, s.SalesAreaId, s.SalesCategory, s.FirstProcessedDate, s.LastProcessedDate, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimDeal] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimDeal] TO [DataServices]
    AS [dbo];
GO
