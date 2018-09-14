CREATE PROCEDURE [dbo].[usp_DeleteAllOldData]
	
AS

SET NOCOUNT ON;

DELETE dbo.FactAllocations WHERE DeletedOn IS NOT NULL
DELETE dbo.FactBudgets WHERE DeletedOn IS NOT NULL
DELETE dbo.FactClientRepresentations WHERE DeletedOn IS NOT NULL
DELETE dbo.FactComments WHERE DeletedOn IS NOT NULL
DELETE dbo.FactDealRightsAllocations WHERE DeletedOn IS NOT NULL
DELETE dbo.FactDeliveries WHERE DeletedOn IS NOT NULL
DELETE dbo.FactOrderDetails WHERE DeletedOn IS NOT NULL
DELETE dbo.FactPipelineDeals WHERE DeletedOn IS NOT NULL
DELETE dbo.FactProjections WHERE DeletedOn IS NOT NULL
DELETE dbo.FactRights WHERE DeletedOn IS NOT NULL
DELETE dbo.FactUserBillingCompanies WHERE DeletedOn IS NOT NULL
DELETE dbo.FactUserProjectionNumbers WHERE DeletedOn IS NOT NULL
DELETE dbo.FactUserRoles WHERE DeletedOn IS NOT NULL
DELETE dbo.FactUsersContracts WHERE DeletedOn IS NOT NULL
DELETE dbo.DimBudget WHERE DeletedOn IS NOT NULL
DELETE dbo.DimClient WHERE DeletedOn IS NOT NULL
DELETE dbo.DimComment WHERE DeletedOn IS NOT NULL
DELETE dbo.DimContract WHERE DeletedOn IS NOT NULL
DELETE dbo.DimCurrency WHERE DeletedOn IS NOT NULL
DELETE dbo.DimCustomerContact WHERE DeletedOn IS NOT NULL
DELETE dbo.DimDeal WHERE DeletedOn IS NOT NULL
DELETE dbo.DimDealProperty WHERE DeletedOn IS NOT NULL
DELETE dbo.DimDealRights WHERE DeletedOn IS NOT NULL
DELETE dbo.DimDelivery WHERE DeletedOn IS NOT NULL
DELETE dbo.DimIncomeType WHERE DeletedOn IS NOT NULL
DELETE dbo.DimInvoicing WHERE DeletedOn IS NOT NULL
DELETE dbo.DimPipelineDeal WHERE DeletedOn IS NOT NULL
DELETE dbo.DimPipelineDealHistory WHERE DeletedOn IS NOT NULL
DELETE dbo.DimProjection WHERE DeletedOn IS NOT NULL
DELETE dbo.DimProjectionAnticipated WHERE DeletedOn IS NOT NULL
DELETE dbo.DimProjectionTerritory WHERE DeletedOn IS NOT NULL
DELETE dbo.DimProperty WHERE DeletedOn IS NOT NULL
DELETE dbo.DimPropertyRights WHERE DeletedOn IS NOT NULL
DELETE dbo.DimRole WHERE DeletedOn IS NOT NULL
DELETE dbo.DimSalesArea WHERE DeletedOn IS NOT NULL
--DELETE dbo.DimUser WHERE DeletedOn IS NOT NULL
DELETE dbo.DimUserBillingCompany WHERE DeletedOn IS NOT NULL
DELETE dbo.DimUserContract WHERE DeletedOn IS NOT NULL
DELETE dbo.DimUserProjectionNumber WHERE DeletedOn IS NOT NULL

RETURN 0;