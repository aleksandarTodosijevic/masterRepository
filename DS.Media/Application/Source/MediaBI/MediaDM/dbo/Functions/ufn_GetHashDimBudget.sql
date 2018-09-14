CREATE FUNCTION [dbo].[ufn_GetHashDimBudget]
(
	@BudgetKey BIGINT
	,@SaleType NVARCHAR(250)
	,@DateOfExpiry DATETIME2(3)
	,@MonthsToExpiry INT
	,@SourceBudgetId INT
	,@YOYGrowth NVARCHAR(50)
	,@PriorityOfEngagementRating DECIMAL(18,2)
	,@EffectiveDate NVARCHAR(10)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @BudgetKey AS BudgetKey
	,@SaleType AS SaleType
	,@DateOfExpiry AS DateOfExpiry
	,@MonthsToExpiry AS MonthsToExpiry
	,@SourceBudgetId AS SourceBudgetId
	,@YOYGrowth AS YOYGrowth
	,@PriorityOfEngagementRating AS PriorityOfEngagementRating
	,@EffectiveDate AS EffectiveDate
	FOR XML RAW('r')))
END