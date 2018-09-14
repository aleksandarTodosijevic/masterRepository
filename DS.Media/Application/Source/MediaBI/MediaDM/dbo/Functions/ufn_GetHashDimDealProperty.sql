Create FUNCTION [dbo].[ufn_GetHashDimDealProperty]
(
	 @DealPropertyKey BIGINT
	,@SourceOrderDetailId INT
	,@ClientName VARCHAR(160)
	,@InvoicingCompany VARCHAR(80)
	,@CompanyCode CHAR(3)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @DealPropertyKey AS DealPropertyKey
	,@SourceOrderDetailId AS SourceOrderDetailId
	,@ClientName AS ClientName
	,@InvoicingCompany AS InvoicingCompany
	,@CompanyCode AS CompanyCode
	FOR XML RAW('r')))
END