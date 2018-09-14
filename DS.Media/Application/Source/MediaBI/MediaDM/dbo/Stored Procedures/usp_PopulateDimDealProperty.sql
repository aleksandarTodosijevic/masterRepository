CREATE PROCEDURE [dbo].[usp_PopulateDimDealProperty]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

DROP TABLE IF EXISTS #DimDealProperty




------------ License End and Start dates -----------------
DROP TABLE IF EXISTS #tempLicenseDates
Select 
	oh.Id AS DealId
	,rd.OrderDetailId
	,od.ProductId AS ProductId
	,MIN(rd.LicenseStartDate) AS LicenseStartDate
	,MAX(rd.LicenseEndDate) AS LicenseEndDate
	INTO #tempLicenseDates
FROM  [$(MediaDMStaging)].dbo.OrderDetailRightsDetail rd
INNER JOIN  [$(MediaDMStaging)].dbo.OrderDetail od ON od.Id = rd.OrderDetailId
INNER JOIN  [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = od.OrderHeaderId
GROUP BY oh.Id, rd.OrderDetailId, od.ProductId
CREATE CLUSTERED INDEX CI_LicenseDates ON #tempLicenseDates (DealId, ProductId)


SELECT 
	DealPropertyKey
	,SourceOrderDetailID
	,ClientName
	,InvoicingCompany
	,CompanyCode
    ,dbo.ufn_GetHashDimDealProperty(DealPropertyKey, SourceOrderDetailID, ClientName, InvoicingCompany, CompanyCode) AS HashKey
    ,NULL AS DeletedOn
	INTO #DimDealProperty
FROM ( 
	SELECT
		dbo.CreateKeyFromSourceID(d.Id) AS DealPropertyKey
		,d.Id AS SourceOrderDetailID
		,COALESCE(c.ClientName, 'No Client') AS ClientName
		,COALESCE(bc.Description, 'N/A') AS InvoicingCompany
		,COALESCE(bc.SAPCompanyCode, 'N/A') AS CompanyCode
	FROM [$(MediaDMStaging)].dbo.OrderDetail d
	LEFT JOIN [$(MediaDMStaging)].dbo.BillingCompany_lu bc ON bc.Id = d.BillingCompanyId
	LEFT JOIN (
		SELECT
			OrderDetailId,
			CASE COUNT(DISTINCT ClientId)
				WHEN 0 THEN 'No Client'
				WHEN 1 THEN MAX(ClientFullName)
				ELSE 'Muliple Clients'
			END AS ClientName
		FROM [$(MediaDMStaging)].dbo.OrderDetailProductClient odpc
		INNER JOIN [$(MediaDMStaging)].dbo.Client c ON c.Id = odpc.ClientId
		GROUP BY OrderDetailId
	) AS c ON c.OrderDetailId = d.Id
	LEFT JOIN #tempLicenseDates ld ON d.OrderHeaderId = ld.DealId AND d.ProductId = ld.ProductId

	UNION

	SELECT
		dbo.CreateKeyFromSourceID(-1) AS DealPropertyKey
		,-1 AS SourceOrderDetailID
		,'N/A' AS ClientName
		,'N/A' AS InvoicingCompany
		,'N/A' AS CompanyCode
) tt

CREATE CLUSTERED INDEX CI_DealProperty ON #DimDealProperty (DealPropertyKey)


MERGE 
    dbo.DimDealProperty t
USING 
    #DimDealProperty s ON (t.DealPropertyKey = s.DealPropertyKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.DealPropertyKey = s.DealPropertyKey
	    ,t.SourceOrderDetailID = s.SourceOrderDetailID
		,t.ClientName = s.ClientName
		,t.InvoicingCompany = s.InvoicingCompany
		,t.CompanyCode = s.CompanyCode
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (DealPropertyKey, SourceOrderDetailID, ClientName, InvoicingCompany, CompanyCode,HashKey)
    VALUES (s.DealPropertyKey, s.SourceOrderDetailID, s.ClientName, s.InvoicingCompany, s.CompanyCode,s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimDealProperty] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimDealProperty] TO [DataServices]
    AS [dbo];
GO
