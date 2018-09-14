CREATE PROCEDURE [dbo].[usp_PopulateDimBudget]
AS
SET NOCOUNT ON;

/*temporary fix*/
exec [dbo].[usp_TruncateTable] 'dbo', 'DimBudget'
----------------

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimBudget') IS NOT NULL DROP TABLE #DimBudget

SELECT * INTO #DimBudget FROM dbo.DimBudget WHERE 1 = 2;

INSERT INTO #DimBudget

SELECT 
	BudgetKey
	,SaleType
	,DateOfExpiry
	,MonthsToExpiry
	,SourceBudgetId
	,YOYGrowth
	,PriorityOfEngagementRating
	,EffectiveDateQuarter
    ,dbo.ufn_GetHashDimBudget(BudgetKey, SaleType, DateOfExpiry, MonthsToExpiry, SourceBudgetId, YOYGrowth, PriorityOfEngagementRating, EffectiveDateQuarter) AS HashKey
    ,NULL AS DeletedOn
FROM (

SELECT 
	BudgetKey
	,SaleType
	,DateOfExpiry
	,MonthsToExpiry
	,SourceBudgetId
	,YOYGrowth
	,CASE
		WHEN  (Forecast/1000000.00)*(cast(MonthsToExpiry as decimal(10,2))) <> 0 THEN
			CAST(((Forecast/1000000.00) * (MonthsToExpiry) + (BudgetDelta/500000.00)) AS DECIMAL(18,2)) -- Formula from excel "Property portfolio"
		ELSE 0
	END AS PriorityOfEngagementRating
	,[EffectiveDateQuarter]

FROM
(
	SELECT 
		dbo.CreateKeyFromSourceID(sp.[ID]) AS BudgetKey
		,COALESCE(sp.[SaleType_Name], 'N/A') AS SaleType
		,COALESCE(sp.[DateOfExpiry], '1900-01-01') AS DateOfExpiry
		,CASE 
			WHEN sp.[DateOfExpiry] IS NULL THEN
				0
			ELSE
				DATEDIFF(Month,GETDATE(), sp.[DateOfExpiry])
		END MonthsToExpiry
		,sp.[ID] AS SourceBudgetId
		,CASE
			WHEN sp.[200A_PreviousYear] = 0 AND sp.Forecast <> 0
				THEN N'New Business' 
			WHEN sp.[200A_PreviousYear] <> 0 AND sp.Forecast <> 0
				THEN CAST(CAST(((sp.Forecast - sp.[200A_PreviousYear]) / ABS(sp.[200A_PreviousYear])) * 100 AS DECIMAL(18,2)) AS VARCHAR(20)) + N'%'
			ELSE N'N/A'
		END AS YOYGrowth
		,sp.Forecast
		,COALESCE(sp.[EffectiveDate], 'N/A') AS [EffectiveDateQuarter]
		--,--Budgets[Forecast] - Budgets[Budget]
		,(sp.Forecast - sp.BudgetTotal) AS BudgetDelta
  FROM [$(MediaDMStaging)].[dbo].[MDS_SalesPortfolio] sp
) as t
  UNION ALL

  SELECT 
	dbo.CreateKeyFromSourceID(-1) AS BudgetKey
	,'N/A' AS SaleType
	,'1900-01-01' AS DateOfExpiry
	,0 AS MonthsToExpiry
	,-1 AS SourceBudgetId
	, N'N/A' AS YOYGrowth
	,0 AS PriorityOfEngagementRating
	,'N/A' AS [EffectiveDateQuarter]
) as tt


MERGE 
    dbo.DimBudget t
USING 
    #DimBudget s ON (t.BudgetKey = s.BudgetKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.BudgetKey = s.BudgetKey,
		t.SaleType = s.SaleType,
		t.DateOfExpiry = s.DateOfExpiry,
		t.MonthsToExpiry = s.MonthsToExpiry,
		t.SourceBudgetId = s.SourceBudgetId,
		t.YOYGrowth = s.YOYGrowth,
		t.EffectiveDateQuarter = s.EffectiveDateQuarter,
		t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BudgetKey, SaleType, DateOfExpiry, MonthsToExpiry, SourceBudgetId, YOYGrowth, PriorityOfEngagementRating, EffectiveDateQuarter, HashKey)
    VALUES (s.BudgetKey, s.SaleType, s.DateOfExpiry, s.MonthsToExpiry, s.SourceBudgetId, s.YOYGrowth, s.PriorityOfEngagementRating, s.EffectiveDateQuarter, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0;

  GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimBudget] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimBudget] TO [DataServices]
    AS [dbo];
GO