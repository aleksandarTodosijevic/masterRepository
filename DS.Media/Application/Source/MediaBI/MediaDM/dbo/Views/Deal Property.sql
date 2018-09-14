

CREATE VIEW [dbo].[Deal Property]
AS SELECT
	DealPropertyKey AS [Deal Property Key]
    ,ClientName AS [Client Name]
	,InvoicingCompany AS [Invoicing Company]
	,CompanyCode AS [Company Code]
FROM dbo.DimDealProperty
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal Property] TO [DataServices]
    AS [dbo];

