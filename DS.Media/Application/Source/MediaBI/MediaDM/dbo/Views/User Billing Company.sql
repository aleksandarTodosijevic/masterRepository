
CREATE VIEW [dbo].[User Billing Company]
	AS 
SELECT 
	 [UserBillingCompanyKey] AS [User Billing Company Key]
    ,[BillingCompanyId] AS [Billing Company Id]
    ,[BillingCompany] AS [Billing Company]
  FROM [DimUserBillingCompany]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Billing Company] TO [DataServices]
    AS [dbo];

