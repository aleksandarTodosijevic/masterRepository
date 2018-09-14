Create FUNCTION [dbo].[ufn_GetHashDimCurrency]
(
	 @CurrencyKey BIGINT
	,@SourceCurrencyId INT
	,@CurrencyCode CHAR(3)
	,@CurrencyDescription VARCHAR(50)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CurrencyKey AS CurrencyKey
	,@SourceCurrencyId AS SourceCurrencyId
	,@CurrencyCode AS CurrencyCode
	,@CurrencyDescription AS CurrencyDescription
	FOR XML RAW('r')))
END