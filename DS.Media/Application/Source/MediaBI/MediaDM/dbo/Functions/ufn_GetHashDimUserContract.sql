Create FUNCTION [dbo].[ufn_GetHashDimUserContract]
(
	 @UserContractKey BIGINT
	,@BillingCompany VARCHAR(80)
	,@LicensorParty VARCHAR(80)
	,@IssueSiteStatusId INT
	,@IssueSite VARCHAR(80)
	,@SelectedLicensingCompanies VARCHAR(163)
	,@LegalOnlineContact VARCHAR(120)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @UserContractKey AS UserContractKey
	,@BillingCompany AS BillingCompany
	,@LicensorParty AS LicensorParty
	,@IssueSiteStatusId AS IssueSiteStatusId
	,@IssueSite AS IssueSite
	,@SelectedLicensingCompanies AS SelectedLicensingCompanies
	,@LegalOnlineContact AS LegalOnlineContact
	FOR XML RAW('r')))
END