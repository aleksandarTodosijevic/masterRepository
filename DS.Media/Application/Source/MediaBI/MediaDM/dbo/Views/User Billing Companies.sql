
CREATE VIEW [dbo].[User Billing Companies]
	AS 
SELECT 
	[UserBillingCompanyKey] AS [User Billing Company Key],
	UserKey AS [User Key],
	CountOfBillingCompanies AS [CountOfBillingCompanies_]
FROM [FactUserBillingCompanies]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Billing Companies] TO [DataServices]
    AS [dbo];

