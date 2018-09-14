
CREATE VIEW [dbo].Budget
AS
SELECT [BudgetKey] AS [Budget Key]
      ,[SaleType] AS [Sale Type]
      ,[DateOfExpiry] AS [Date Of Expiry]
      ,[MonthsToExpiry] AS [Months To Expiry]
	  ,[YOYGrowth] AS [YOY Growth]
	  ,[PriorityOfEngagementRating] AS [Priority Of Engagement Rating]
	  ,[EffectiveDateQuarter] AS [Effective Date Quarter]
  FROM [dbo].[DimBudget]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Budget] TO [DataServices]
    AS [dbo];

