Create FUNCTION [dbo].[ufn_GetHashDimUserBillingCompany]
(
	 @UserBillingCompanyKey BIGINT
	,@BillingCompanyId INT
	,@BillingCompany VARCHAR(80)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @UserBillingCompanyKey AS UserBillingCompanyKey
	,@BillingCompanyId AS BillingCompanyId
	,@BillingCompany AS BillingCompany
	FOR XML RAW('r')))
END