
CREATE VIEW [dbo].[User Contract]
	AS 
SELECT 
	UserContractKey AS [User Contract Key],
	BillingCompany AS [Billing Company],
	LicensorParty AS [Licensor Party],
	IssueSiteStatusId AS [Issue Site Status Id],
	IssueSite AS [Issue Site],
	SelectedLicensingCompanies AS [Selected Licensing Companies],
	LegalOnlineContact AS [Legal Online Contact]
FROM [DimUserContract]
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Contract] TO [DataServices]
    AS [dbo];
GO
