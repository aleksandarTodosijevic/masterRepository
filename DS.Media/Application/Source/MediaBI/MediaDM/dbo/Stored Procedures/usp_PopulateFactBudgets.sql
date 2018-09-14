CREATE PROCEDURE [dbo].[usp_PopulateFactBudgets]
AS
SET NOCOUNT ON;

/*temporary fix*/
exec [dbo].[usp_TruncateTable] 'dbo', 'FactBudgets'
----------------

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactBudgets') IS NOT NULL DROP TABLE #FactBudgets

SELECT * INTO #FactBudgets FROM dbo.FactBudgets WHERE 1 = 2;

IF OBJECT_ID('tempdb..#tempPropertyProjection') IS NOT NULL drop table #tempPropertyProjection

SELECT 
DISTINCT ProjectionNo, ProjectionNoT
INTO #tempPropertyProjection
FROM [$(MediaDMStaging)].dbo.Product p


INSERT INTO #FactBudgets 
   (BudgetKey, ProjectionKey, [ProjectionYear], Budget, PreviousYearActual, [Forecast], MonthsToExpiry, HashKey, DeletedOn)
SELECT 
	 BudgetKey
	,ProjectionKey
	,[ProjectionYear]
	,Budget
	,PreviousYearActual
	,[Forecast]
	,MonthsToExpiry
	,dbo.ufn_GetHashFactBudgets (Budget, PreviousYearActual, Forecast, MonthsToExpiry) AS HashKey
    ,NULL AS DeletedOn
FROM (

	SELECT DISTINCT
		dbo.CreateKeyFromSourceID(COALESCE(sp.ID, '-1')) BudgetKey
		,dbo.CreateKeyFromSourceID(COALESCE(p.ProjectionNo, '-1') + ':' + COALESCE(p.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sp.[SubjectCategory_ID] AS VARCHAR(10) ), '-1')) ProjectionKey
		,COALESCE(sp.[Year_ID], 1990) AS [ProjectionYear]
		,COALESCE(sp.BudgetTotal, 0) AS Budget
		,COALESCE(sp.[200A_PreviousYear], 0) AS PreviousYearActual
		,COALESCE(sp.[Forecast], 0) AS [Forecast]
		,CASE 
				WHEN sp.[DateOfExpiry] IS NULL THEN
					0
				ELSE
					DATEDIFF(Month,GETDATE(), sp.[DateOfExpiry])
			END MonthsToExpiry
	FROM [$(MediaDMStaging)].[dbo].MDS_SalesPortfolio sp 
	INNER JOIN #tempPropertyProjection p ON p.ProjectionNo = sp.T_Number
) tt;


MERGE 
    dbo.FactBudgets AS t
USING 
    #FactBudgets AS s ON (
				t.BudgetKey = s.BudgetKey
			AND t.ProjectionKey = s.ProjectionKey
			AND t.[ProjectionYear] = s.[ProjectionYear]
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		    t.Budget = s.Budget
		   ,t.PreviousYearActual = s.PreviousYearActual
		   ,t.Forecast = s.Forecast
		   ,t.MonthsToExpiry = s.MonthsToExpiry
		   ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BudgetKey, ProjectionKey, [ProjectionYear], Budget, PreviousYearActual, [Forecast], MonthsToExpiry, HashKey)
    VALUES (s.BudgetKey, s.ProjectionKey, s.[ProjectionYear], s.Budget, s.PreviousYearActual, s.[Forecast], s.MonthsToExpiry, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactBudgets] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactBudgets] TO [DataServices]
    AS [dbo];
GO
