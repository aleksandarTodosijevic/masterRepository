cReate FUNCTION [dbo].[ufn_GetHashFactBudgets]
(    @Budget DECIMAL(38,2)
    ,@PreviousYearActual DECIMAL(38,2)
	,@Forecast DECIMAL(38,2)
	,@MonthsToExpiry INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @Budget AS Budget
    ,@PreviousYearActual AS PreviousYearActual
	,@Forecast AS Forecast
	,@MonthsToExpiry AS MonthsToExpiry
	FOR XML RAW('r')))
END