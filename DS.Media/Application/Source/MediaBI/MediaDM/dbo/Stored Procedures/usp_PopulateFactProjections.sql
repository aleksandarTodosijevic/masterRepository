CREATE PROCEDURE [dbo].[usp_PopulateFactProjections]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactProjections') IS NOT NULL DROP TABLE #FactProjections

SELECT * INTO #FactProjections FROM dbo.FactProjections WHERE 1 = 2;

-- Actuals
IF OBJECT_ID('tempdb..#tempActuals') IS NOT NULL drop table #tempActuals

SELECT 
	ia.ProductId,
	oh.SalesAreaId, 
	it.MasterIncomeTypeId AS IncomeTypeId,
	ia.ProjectionYear, 
	oh.CustomerId, 
	ia.TerritoryId,
	ia.CurrencyId, 
	SUM(ia.Amount) as ActualAmount, 
	SUM(ia.USDollarEquivalent) as ActualUSAmount
INTO #tempActuals
FROM [$(MediaDMStaging)].dbo.InternalAllocation ia WITH (NOLOCK)
INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh WITH (NOLOCK) ON oh.Id = ia.OrderHeaderId
INNER JOIN [$(MediaDMStaging)].[dbo].[vw_IncomeType] it WITH (NOLOCK) ON  ia.IncomeTypeId = it.IncomeTypeId
WHERE 
	(ia.InvoiceWasCancelled = 0) 
	AND ia.StatusId = 1
	AND oh.OrderStatusId NOT IN (1,4) AND oh.ProcessedDate < GETDATE() AND oh.StatusId = 1
GROUP BY 
	ia.ProductId,
	oh.SalesAreaId, 
	it.MasterIncomeTypeId,
	ia.ProjectionYear, 
	oh.CustomerId, 
	ia.TerritoryId,
	ia.CurrencyId
CREATE CLUSTERED INDEX CI_Actuals ON #tempActuals (ProductId,SalesAreaId,IncomeTypeId,ProjectionYear,CustomerId,TerritoryId,CurrencyId) 

-- temp Anticipated
IF OBJECT_ID('tempdb..#tblAnticipated') IS NOT NULL drop table #tblAnticipated
SELECT 
	pj.Id AS ProjectionId
	,pr.Id AS ProductId
	,pjh.SalesAreaId
	,pjh.IncomeTypeId
	,pjh.ProjectionYear  
	,pj.CustomerId
	,pj.TerritoryId
	,pj.AnticipatedCcyId  AS CurrencyId
    ,CASE WHEN (pdp.PipelineDealId IS NOT NULL AND pdp.PipelineDealId <> 0) THEN pdp.PipelineDealId
	      WHEN max(pj.PipelineDealId) <> 0 THEN max(pj.PipelineDealId)
		  ELSE -1
	 END AS PipelineDealId	   
	,SUM(
	  CASE WHEN pdp.Id IS NULL THEN pj.AnticipatedAmount
	  ELSE pdp.AnticipatedAmount
	  END
	) as AnticipatedAmount 
	,SUM(
	  CASE WHEN pdp.Id IS NULL THEN pj.AnticipatedAmountUSD
	  ELSE pdp.AnticipatedAmountUSD
	  END
	) as AnticipatedUSAmount
	,SUM(
	  CASE WHEN pdp.Id IS NULL THEN pj.TargetAmount
	  ELSE pdp.TargetAmount
	  END
	) as TargetAmount
	,SUM(
	  CASE WHEN pdp.Id IS NULL THEN pj.TargetAmountUSD
	  ELSE pdp.TargetAmountUSD
	  END
	) as TargetUSAmount
INTO #tblAnticipated
FROM [$(MediaDMStaging)].dbo.ProjectionHeader pjh WITH (NOLOCK) 
	INNER JOIN [$(MediaDMStaging)].dbo.Projection pj WITH (NOLOCK) ON pj.ProjectionHeaderId = pjh.Id
	INNER JOIN [$(MediaDMStaging)].dbo.Product pr WITH (NOLOCK) ON pr.Id = pj.ProductId
	INNER JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pn WITH (NOLOCK) ON pn.Id = pr.ProjectionNo
	LEFT JOIN [$(MediaDMStaging)].dbo.PipelineDealProjection pdp WITH (NOLOCK) ON pdp.ProjectionId = pj.Id AND pdp.StatusId = 1
WHERE
	pj.StatusId = 1 AND pjh.StatusId = 1 
GROUP BY pj.Id,pr.Id, pjh.SalesAreaId, pjh.IncomeTypeId, pjh.ProjectionYear, pj.CustomerId, pj.TerritoryId, pj.AnticipatedCcyId, pdp.PipelineDealId
CREATE CLUSTERED INDEX CI_Actuals ON #tblAnticipated (ProductId,SalesAreaId,IncomeTypeId,ProjectionYear,CustomerId,TerritoryId,CurrencyId) 


INSERT INTO #FactProjections 
   (ProjectionYear, SalesAreaKey, IncomeTypeKey, PropertyKey, ProjectionKey, 
	CustomerContactKey, ProjectionTerritoryKey, CurrencyKey, [ProjectionAnticipatedKey], [PipelineDealKey],
	AnticipatedAmount, AnticipatedAmountUSD, [ActualAmount], [ActualAmountUSD], [TargetAmount], [TargetAmountUSD], [SalesProgress], HashKey, DeletedOn)
SELECT 
	 ProjectionYear
	,SalesAreaKey
	,IncomeTypeKey
	,PropertyKey
	,ProjectionKey 
	,CustomerContactKey
	,ProjectionTerritoryKey
	,CurrencyKey
	,[ProjectionAnticipatedKey]
	,[PipelineDealKey]
	,AnticipatedAmount
	,AnticipatedAmountUSD
	,[ActualAmount]
	,[ActualAmountUSD]
	,[TargetAmount]
	,[TargetAmountUSD]
	,[SalesProgress]
	,dbo.ufn_GetHashFactProjections (AnticipatedAmount, AnticipatedAmountUSD, ActualAmount, ActualAmountUSD
									,TargetAmount, SalesProgress, TargetAmountUSD) AS HashKey
    ,NULL AS DeletedOn
FROM (
	SELECT 
		a.ProjectionYear
		,dbo.CreateKeyFromSourceID(a.SalesAreaId) as SalesAreaKey
		,dbo.CreateKeyFromSourceID(a.IncomeTypeId) as IncomeTypeKey
		,dbo.CreateKeyFromSourceID(a.ProductId) as PropertyKey
		,dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
		,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), a.CustomerId)
			+':'+CONVERT(VARCHAR(10), -1)
			+':'+CONVERT(VARCHAR(10), -1)
		 ) as CustomerContactKey
		,dbo.CreateKeyFromSourceID(a.TerritoryId) as ProjectionTerritoryKey
		,dbo.CreateKeyFromSourceID(a.CurrencyId) as CurrencyKey
		,dbo.CreateKeyFromSourceID(a.ProjectionAnticipatedId) AS [ProjectionAnticipatedKey]
		,dbo.CreateKeyFromSourceID(PipelineDealId) AS [PipelineDealKey]
		,a.AnticipatedAmount
		,a.AnticipatedAmountUSD
		,a.ActualAmount
		,a.ActualAmountUSD
		,a.TargetAmount
		,a.TargetAmountUSD
		,COALESCE((p.SalesProgress / 100), 0) AS SalesProgress 
	FROM 
	(
		SELECT DISTINCT
			ISNULL(ant.ProjectionYear, act.ProjectionYear) AS ProjectionYear
			,ISNULL(ant.SalesAreaId, act.SalesAreaId) AS SalesAreaId
			,ISNULL(ant.IncomeTypeId, act.IncomeTypeId) AS IncomeTypeId
			,ISNULL(ant.ProductId, act.ProductId) AS ProductId
			,ISNULL(ant.CustomerId, act.CustomerId) AS CustomerId
			,ISNULL(ant.TerritoryId, act.TerritoryId) AS TerritoryId
			,ISNULL(ant.CurrencyId, act.CurrencyId) AS CurrencyId
			,ISNULL(ant.ProjectionId, -1) AS ProjectionAnticipatedId
			,ISNULL(ant.PipelineDealId, -1) AS PipelineDealId
			,ISNULL(ant.AnticipatedAmount, 0) AS AnticipatedAmount
			,ISNULL(ant.AnticipatedUSAmount, 0) AS AnticipatedAmountUSD
			,ISNULL(act.ActualAmount, 0) AS ActualAmount
			,ISNULL(act.ActualUSAmount, 0) AS ActualAmountUSD
			,ISNULL(ant.TargetAmount, 0) AS TargetAmount
			,ISNULL(ant.TargetUSAmount, 0) AS TargetAmountUSD
		FROM #tblAnticipated ant
		FULL OUTER JOIN #tempActuals act
			ON ant.ProjectionYear = act.ProjectionYear
			AND ant.SalesAreaId = act.SalesAreaId
			AND ant.IncomeTypeId = act.IncomeTypeId
			AND ant.ProductId = act.ProductId
			AND ant.CustomerId = act.CustomerId
			AND ant.TerritoryId = act.TerritoryId
			AND ant.CurrencyId = act.CurrencyId
	) AS a
	LEFT JOIN [$(MediaDMStaging)].dbo.Product  pr WITH (NOLOCK) ON a.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc WITH (NOLOCK) ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.PipelineDeal p WITH (NOLOCK) ON a.PipelineDealId = p.Id
) tt;



MERGE 
    dbo.FactProjections AS t
USING 
    #FactProjections AS s ON (
				t.ProjectionYear = s.ProjectionYear
			AND t.SalesAreaKey = s.SalesAreaKey
			AND t.IncomeTypeKey = s.IncomeTypeKey
			AND t.PropertyKey = s.PropertyKey
			AND t.ProjectionKey = s.ProjectionKey
			AND t.CustomerContactKey = s.CustomerContactKey
			AND t.ProjectionTerritoryKey = s.ProjectionTerritoryKey
			AND t.CurrencyKey = s.CurrencyKey
			AND t.[ProjectionAnticipatedKey] = s.[ProjectionAnticipatedKey]
			AND t.[PipelineDealKey] = s.[PipelineDealKey]
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		    t.AnticipatedAmount = s.AnticipatedAmount
		   ,t.AnticipatedAmountUSD = s.AnticipatedAmountUSD
		   ,t.[ActualAmount] = s.ActualAmount
		   ,t.[ActualAmountUSD] = s.[ActualAmountUSD]
		   ,t.[TargetAmount] = s.[TargetAmount]
		   ,t.[TargetAmountUSD] = s.[TargetAmountUSD]
		   ,t.[SalesProgress] = s.[SalesProgress]
		   ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProjectionYear, SalesAreaKey, IncomeTypeKey, PropertyKey, ProjectionKey, 
	CustomerContactKey, ProjectionTerritoryKey, CurrencyKey, [ProjectionAnticipatedKey], [PipelineDealKey],
	AnticipatedAmount, AnticipatedAmountUSD, [ActualAmount], [ActualAmountUSD], [TargetAmount], [TargetAmountUSD], [SalesProgress], HashKey)
    VALUES (s.ProjectionYear, s.SalesAreaKey, s.IncomeTypeKey, s.PropertyKey, s.ProjectionKey, 
	s.CustomerContactKey, s.ProjectionTerritoryKey, s.CurrencyKey, s.[ProjectionAnticipatedKey], s.[PipelineDealKey],
	s.AnticipatedAmount, s.AnticipatedAmountUSD, s.[ActualAmount], s.[ActualAmountUSD], s.[TargetAmount], s.[TargetAmountUSD], s.[SalesProgress], s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactProjections] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactProjections] TO [DataServices]
    AS [dbo];
GO
