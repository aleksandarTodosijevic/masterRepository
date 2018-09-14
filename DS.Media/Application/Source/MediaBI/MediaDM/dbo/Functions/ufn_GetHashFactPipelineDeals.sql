cReate FUNCTION [dbo].[ufn_GetHashFactPipelineDeals]
(    @SalesProgress NUMERIC(13,6)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @SalesProgress AS SalesProgress
	FOR XML RAW('r')))
END