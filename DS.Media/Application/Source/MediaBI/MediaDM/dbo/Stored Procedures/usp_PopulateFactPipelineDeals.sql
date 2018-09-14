CREATE PROCEDURE [dbo].[usp_PopulateFactPipelineDeals]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactPipelineDeals') IS NOT NULL DROP TABLE #FactPipelineDeals

SELECT * INTO #FactPipelineDeals FROM dbo.FactPipelineDeals WHERE 1 = 2;


INSERT INTO #FactPipelineDeals 
   ([PipelineDealHistoryKey], [PipelineDealKey], [DealKey], [SalesProgress], [ProjectionKey], [PropertyKey], [CustomerContactKey], [SalesAreaKey], DeletedOn)
SELECT 
	 [PipelineDealHistoryKey]
	,[PipelineDealKey]
    ,[DealKey]
    ,[SalesProgress]
	,[ProjectionKey] 
	,[PropertyKey]
	,[CustomerContactKey]
	,[SalesAreaKey]
	,NULL AS DeletedOn
FROM (
	SELECT 
		dbo.CreateKeyFromSourceID(pdh.Id) AS PipelineDealHistoryKey
		,dbo.CreateKeyFromSourceID(pdh.PipelineDealId) AS PipelineDealKey
		,dbo.CreateKeyFromSourceID(COALESCE(oh.Id, -1)) AS DealKey
		,pdh.SalesProgress / 100 AS SalesProgress
		,dbo.CreateKeyFromSourceID(COALESCE(prd.ProjectionNo, '-1') + ':' + COALESCE(prd.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
				   -- Should we remove Projections from this fact? some Pipelines are in more Projections - f.e. PipelineDealId = 1204
		,dbo.CreateKeyFromSourceID(COALESCE(pr.ProductId, -1)) AS PropertyKey
		,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), ISNULL(pr.CustomerId,-1))
		+':'+CONVERT(VARCHAR(10), -1)
		+':'+CONVERT(VARCHAR(10), -1)
		) AS CustomerContactKey
		,dbo.CreateKeyFromSourceID(COALESCE(prh.SalesAreaId, -1)) AS SalesAreaKey
	FROM [$(MediaDMStaging)].dbo.PipelineDeal pd
	INNER JOIN [$(MediaDMStaging)].dbo.PipelineDealHistory pdh ON pd.Id = pdh.PipelineDealId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[OrderHeader] oh ON pd.Id = oh.SourcePipelineDealId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[PipelineDealProjection] pdp ON pdp.PipelineDealId = pd.Id AND pdp.StatusId = 1
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Projection] pr ON pr.PipelineDealId = pdp.PipelineDealId and pdp.ProjectionId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[ProjectionHeader] prh ON pr.ProjectionHeaderId = prh.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Product] prd ON pr.ProductId = prd.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[SubjectCategory_lu] sc ON sc.Id = prd.SubjectCategoryId
	WHERE (oh.Id IS NULL OR oh.StatusId = 1) AND pdh.StatusId = 1 AND pd.StatusId = 1 
) tt;



MERGE 
    dbo.FactPipelineDeals AS t
USING 
    #FactPipelineDeals AS s ON (
				t.[PipelineDealHistoryKey] = s.[PipelineDealHistoryKey]
			AND t.[PipelineDealKey] = s.[PipelineDealKey]
			AND t.[DealKey] = s.[DealKey]
			AND t.[ProjectionKey] = s.[ProjectionKey]
			AND t.[PropertyKey] = s.[PropertyKey]
			AND t.[CustomerContactKey] = s.[CustomerContactKey]
			AND t.[SalesAreaKey] = s.[SalesAreaKey]
					 )
WHEN MATCHED AND (t.SalesProgress <> s.SalesProgress OR t.SalesProgress IS NULL OR t.ProjectionKey IS NULL OR t.PropertyKey IS NULL OR t.CustomerContactKey IS NULL OR t.SalesAreaKey IS NULL) THEN  
    UPDATE SET
			 t.SalesProgress = s.SalesProgress
			,t.ProjectionKey = s.ProjectionKey
			,t.PropertyKey = s.PropertyKey
			,t.CustomerContactKey = s.CustomerContactKey
			,t.SalesAreaKey = s.SalesAreaKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([PipelineDealHistoryKey], [PipelineDealKey], [DealKey], [SalesProgress], [ProjectionKey], [PropertyKey], [CustomerContactKey], [SalesAreaKey])
    VALUES (s.[PipelineDealHistoryKey], s.[PipelineDealKey], s.[DealKey], s.[SalesProgress], s.[ProjectionKey], s.[PropertyKey], s.[CustomerContactKey], s.[SalesAreaKey])
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactPipelineDeals] TO [ETLRole]
    AS [dbo];
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactPipelineDeals] TO [DataServices]
    AS [dbo];
GO



