cReate FUNCTION [dbo].[ufn_GetHashFactUserBillingCompanies]
(    @CountOfBillingCompanies INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CountOfBillingCompanies AS CountOfBillingCompanies
	FOR XML RAW('r')))
END