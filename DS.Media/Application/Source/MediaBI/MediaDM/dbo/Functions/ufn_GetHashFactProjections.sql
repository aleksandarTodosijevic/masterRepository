CREATE FUNCTION [dbo].[ufn_GetHashFactProjections]
(    @AnticipatedAmount MONEY
    ,@AnticipatedAmountUSD MONEY
	,@ActualAmount MONEY
	,@ActualAmountUSD MONEY
	,@TargetAmount DECIMAL(18,2)
	,@SalesProgress NUMERIC(9,2)
	,@TargetAmountUSD MONEY
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @AnticipatedAmount AS AnticipatedAmount
    ,@AnticipatedAmountUSD AS AnticipatedAmountUSD
	,@ActualAmount AS ActualAmount
	,@ActualAmountUSD AS ActualAmountUSD
	,@TargetAmount AS TargetAmount
	,@SalesProgress AS SalesProgress
	,@TargetAmountUSD AS TargetAmountUSD
	FOR XML RAW('r')))
END