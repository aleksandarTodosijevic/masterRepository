
creAte PROCEDURE [dbo].[usp_PopulateFactOrderDetails]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactOrderDetails') IS NOT NULL DROP TABLE #FactOrderDetails

SELECT * INTO #FactOrderDetails FROM dbo.FactOrderDetails WHERE 1 = 2;


INSERT INTO #FactOrderDetails 
   ([ContractKey], [PropertyKey], [ProjectionKey], [DealPropertyKey], [DealKey], [CustomerContactKey], [DealCreatedByKey], [DealCreatedOnDateKey], 
     [DealUpdatedByKey], [DealUpdatedOnDateKey], HashKey, DeletedOn)
SELECT 
	 [ContractKey]
	,[PropertyKey]
	,[ProjectionKey]
	,[DealPropertyKey]
	,[DealKey]
	,[CustomerContactKey]
	,[DealCreatedByKey]
	,[DealCreatedOnDateKey] 
    ,[DealUpdatedByKey]
	,[DealUpdatedOnDateKey]
	,dbo.ufn_GetHashFactOrderDetails([DealCreatedByKey], [DealCreatedOnDateKey], [DealUpdatedByKey], [DealUpdatedOnDateKey]) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT 
	dbo.CreateKeyFromSourceID(ISNULL(c.Id,-1)) AS ContractKey,
	dbo.CreateKeyFromSourceID(od.ProductId) AS PropertyKey,
	dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey,
	dbo.CreateKeyFromSourceID(od.Id) AS DealPropertyKey,
	dbo.CreateKeyFromSourceID(od.OrderHeaderId) AS DealKey,
	dbo.CreateKeyFromSourceID(CAST(ISNULL(oh.CustomerId, -1) AS VARCHAR(10)) 
		+ ':' + CAST(ISNULL(cc.Id,-1) AS VARCHAR(10))
		+ ':' + CAST(ISNULL(c.CustomerAddressId,-1) AS VARCHAR(10))
	) AS CustomerContactKey,
	dbo.CreateKeyFromSourceID(COALESCE(oh.CreatedBy,-1)) AS DealCreatedByKey,
	dbo.CreateKeyFromDate(COALESCE(oh.CreatedDate, '1900-01-01')) AS DealCreatedOnDateKey,
	dbo.CreateKeyFromSourceID(COALESCE(oh.UpdatedBy, oh.CreatedBy, -1)) AS DealUpdatedByKey,
	dbo.CreateKeyFromDate(COALESCE(oh.UpdatedDate, oh.CreatedDate, '1900-01-01')) AS DealUpdatedOnDateKey
FROM [$(MediaDMStaging)].[dbo].[OrderDetail] od
	INNER JOIN [$(MediaDMStaging)].[dbo].[OrderHeader] oh ON oh.Id = od.OrderHeaderId
	LEFT JOIN [$(MediaDMStaging)].dbo.Product pr ON od.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Contract] c ON c.Id = od.ContractId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[CustomerContact] cc ON cc.Id = c.CustomerContactid AND cc.CustomerId = oh.CustomerId
WHERE
	od.StatusId = 1
	AND oh.StatusId = 1
	AND c.StatusId = 1
) tt;

MERGE 
    dbo.FactOrderDetails AS t
USING 
    #FactOrderDetails AS s ON (
				 t.[ContractKey] = s.[ContractKey]
			 AND t.[PropertyKey] = s.[PropertyKey]
		     AND t.[ProjectionKey] = s.[ProjectionKey]
			 AND t.[DealPropertyKey] = s.[DealPropertyKey]
			 AND t.[DealKey] = s.[DealKey]
			 AND t.[CustomerContactKey] = s.[CustomerContactKey]
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
			 t.[DealCreatedByKey] = s.[DealCreatedByKey]
		    ,t.[DealCreatedOnDateKey] = s.[DealCreatedOnDateKey]
			,t.[DealUpdatedByKey] = s.[DealUpdatedByKey]
			,t.[DealUpdatedOnDateKey] = s.[DealUpdatedOnDateKey]
 		    ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([ContractKey], [PropertyKey], [ProjectionKey], [DealPropertyKey], [DealKey], [CustomerContactKey], [DealCreatedByKey], [DealCreatedOnDateKey],
	 [DealUpdatedByKey], [DealUpdatedOnDateKey], HashKey)
    VALUES (s.[ContractKey], s.[PropertyKey], s.[ProjectionKey], s.[DealPropertyKey], s.[DealKey], s.[CustomerContactKey], s.[DealCreatedByKey], s.[DealCreatedOnDateKey],
	 s.[DealUpdatedByKey], s.[DealUpdatedOnDateKey], s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactOrderDetails] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactOrderDetails] TO [DataServices]
    AS [dbo];
GO

