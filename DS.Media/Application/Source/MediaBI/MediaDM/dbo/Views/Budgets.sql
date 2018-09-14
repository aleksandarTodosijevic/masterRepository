

CREATE VIEW [dbo].Budgets
AS
SELECT [BudgetKey] AS [Budget Key]
      ,[ProjectionKey] AS [Projection Key]
      ,[ProjectionYear] AS [Projection Year]
      ,[Budget] AS [Budget]
      ,[PreviousYearActual] AS [ Previous Year Actual]
	  ,[Forecast] AS [Forecast]
	  ,[MonthsToExpiry] AS [Months To Expiry]
  FROM [dbo].[FactBudgets]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Budgets] TO [DataServices]
    AS [dbo];

