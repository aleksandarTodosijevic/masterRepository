CREATE PROCEDURE [dbo].[usp_PopulateDimCustomerContact]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimCustomerContact') IS NOT NULL DROP TABLE #DimCustomerContact

SELECT * INTO #DimCustomerContact FROM dbo.DimCustomerContact WHERE 1 = 2

CREATE CLUSTERED INDEX IC_CustomerContactKey ON #DimCustomerContact(CustomerContactKey);

/* Combination of customers and address from Order invoices, contracts and also direct relation between customer and customerAddress
because there are differencies */

IF OBJECT_ID('tempdb..#CombinationCustomerAdressTemp') IS NOT NULL
DROP TABLE #CombinationCustomerAdressTemp

SELECT cc.CustomerId, cc.Id as ContactId , ca.Id AS CustomerAddressId
INTO #CombinationCustomerAdressTemp
FROM [$(MediaDMStaging)].dbo.CustomerContact  cc
INNER JOIN [$(MediaDMStaging)].dbo.CustomerAddress ca ON cc.CustomerId = ca.CustomerId

UNION
-- For Populate Allocations rights
SELECT DISTINCT
	oh.CustomerId ,cc.Id as ContactId, i.CustomerAddressId
FROM [$(MediaDMStaging)].dbo.InternalAllocation p 
INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = p.OrderHeaderId
LEFT JOIN [$(MediaDMStaging)].dbo.OrderRightsInvoiceOrderDetail id ON id.Id = p.OrderInvoiceId 
LEFT JOIN [$(MediaDMStaging)].dbo.OrderRightsInvoice i ON i.Id = id.OrderRightsInvoiceId
LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.CustomerId = oh.CustomerId AND cc.Id = i.CustomerContactId
--WHERE p.StatusId = 1 AND oh.OrderStatusId <> 1 AND p.FeeTypeId = 1 AND i.BillingCodeId <> 3

UNION
-- For Populate Allocations technical
SELECT DISTINCT
oh.CustomerId ,cc.Id as ContactId, i.CustomerAddressId
FROM [$(MediaDMStaging)].dbo.InternalAllocation p
INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh ON oh.Id = p.OrderHeaderId
LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoiceDetail id ON id.Id = p.OrderInvoiceId
LEFT JOIN [$(MediaDMStaging)].dbo.OrderInvoice i ON i.Id = id.OrderInvoiceId
LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.CustomerId = oh.CustomerId AND cc.Id = i.CustomerContactId


UNION

SELECT DISTINCT
	cc.CustomerId,cc.Id as ContactId, i.CustomerAddressId
FROM
[$(MediaDMStaging)].dbo.OrderInvoice i 
INNER JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.Id = i.CustomerContactId

UNION

--For PopulateFactRights and FactOrderDetails
SELECT DISTINCT oh.CustomerId, cc.Id AS CustomerContactId ,oi.CustomerAddressId
FROM [$(MediaDMStaging)].dbo.OrderDetail od
	INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh
		ON oh.Id = od.OrderHeaderId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Contract] oi ON od.ContractId = oi.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[CustomerContact] cc ON cc.CustomerId = oh.CustomerId AND cc.Id = oi.CustomerContactid


---- Insert into temporary dim table for merge
INSERT INTO #DimCustomerContact (CustomerContactKey, SourceCustomerId, SourceContactId, SourceCustomerAddressId
	, CustomerNo, CustomerName, CustomerShortName, ContactName, ProjectionTerritory, SAPCustomerNumber, SAPPayerNumber, SOLId, 
	RightsSelection, TerritorySelection, LanguageSelection, NumberOfTransmissions, NumberOfTransmissionsName, HashKey, DeletedOn)


SELECT 
	CustomerContactKey
	,SourceCustomerId
	,SourceContactId
	,SourceCustomerAddressId
	,CustomerNo
	,CustomerName
	,CustomerShortName
	,ContactName
	,ProjectionTerritory
	,SAPCustomerNumber
	,SAPPayerNumber
	,SOLId
	,RightsSelection
	,TerritorySelection
	,LanguageSelection
	,NumberOfTransmissions
	,NumberOfTransmissionsName
	,dbo.ufn_GetHashDimCustomerContact(CustomerContactKey, SourceCustomerId, SourceContactId, SourceCustomerAddressId
	,CustomerNo, CustomerName, CustomerShortName, ContactName, ProjectionTerritory, SAPCustomerNumber, SAPPayerNumber, SOLId, 
	RightsSelection, TerritorySelection, LanguageSelection, NumberOfTransmissions, NumberOfTransmissionsName) AS HashKey
    ,NULL AS DeletedOn

FROM (


SELECT
	dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10),CustomerId)
		+':'+ CONVERT(VARCHAR(10), ContactId)
		+':'+ CONVERT(VARCHAR(10), CustomerAddressId)
	 ) AS CustomerContactKey
	,CustomerId AS SourceCustomerId
	,ContactId AS SourceContactId
	,CustomerAddressId AS SourceCustomerAddressId
	,CustomerNo
	,CustomerFullName AS CustomerName
	,ShortName AS CustomerShortName
	,ContactName
	,[Description] AS ProjectionTerritory
	,[SAPCustomerNumber]
	,[PayerNumber] AS [SAPPayerNumber]
	,[SOLId] AS [SOLId]
	,[RightsSelection]
	,[TerritorySelection]
	,[LanguageSelection]
	,[NumberOfTransmissions]
	,[NumberOfTransmissionsName]
FROM (
	SELECT
		COALESCE(cca.CustomerId, -1) AS [CustomerId]
		,COALESCE(cca.ContactId, -1) AS [ContactId]
		,COALESCE(cca.CustomerAddressId, -1) AS [CustomerAddressId]
		,COALESCE(c.CustomerNo,-1) AS [CustomerNo]
		,c.[CustomerFullName]
		,c.[ShortName]
		,COALESCE(cc.ContactName, 'N/A') AS [ContactName]
		,COALESCE(t.[Description], 'N/A') AS [Description]
		,COALESCE(sc.[SAPCustomerNumber], 'N/A') AS [SAPCustomerNumber]
		,COALESCE(ca.PayerNumber, 'N/A') AS [PayerNumber]
		,c.Id AS [SOLId]
		,COALESCE(rse.[Description], 'N/A') AS [RightsSelection]
		,COALESCE(tse.[Description], 'N/A') AS [TerritorySelection]
		,COALESCE(lse.[Description], 'N/A') AS [LanguageSelection]
		,COALESCE(c.[NumberOfTransmissions], 0) AS [NumberOfTransmissions]
		,CASE
			WHEN c.[NumberOfTransmissions] = -2 THEN 'No Set'
			WHEN c.[NumberOfTransmissions] = -1 THEN 'Unlimited Transmissions'
			WHEN c.[NumberOfTransmissions] = -3 THEN 'Holdback'
			WHEN c.[NumberOfTransmissions] = 2 THEN '2'
			WHEN c.[NumberOfTransmissions] = -4 THEN 'Values'
			WHEN c.[NumberOfTransmissions] = -5 THEN 'Dark Period'
			WHEN c.[NumberOfTransmissions] = -6 THEN 'Exclusive Option to Extend'
			WHEN c.[NumberOfTransmissions] IS NOT NULL THEN CAST(c.[NumberOfTransmissions] AS varchar(30))
			ELSE 'N/A'
		END AS NumberOfTransmissionsName
	FROM #CombinationCustomerAdressTemp cca
		INNER JOIN [$(MediaDMStaging)].dbo.Customer c ON cca.CustomerId = c.Id
		LEFT JOIN [$(MediaDMStaging)].dbo.CustomerAddress ca on ca.Id = cca.CustomerAddressId
		LEFT JOIN [$(MediaDMStaging)].dbo.CustomerContact cc ON cc.Id = cca.ContactId
		LEFT JOIN [$(MediaDMStaging)].dbo.Territory_lu t ON t.Id = c.ProjectionTerritoryId
		LEFT JOIN [$(MediaDMStaging)].dbo.SAPCustomer sc ON cca.ContactId = sc.CustomerContactId 
																AND cca.CustomerId = sc.CustomerId
																AND cca.CustomerAddressId = sc.CustomerAddressId
		LEFT JOIN [$(MediaDMStaging)].[dbo].[RightsSelectionEx] rse ON c.[RightsSelectionId] = rse.Id
		LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritorySelectionEx] tse ON c.[TerritorySelectionId] = tse.Id
		LEFT JOIN [$(MediaDMStaging)].[dbo].[LanguageSelectionEx] lse ON c.[LanguageSelectionId] = lse.Id

	UNION 
	
	SELECT
		c.Id AS CustomerId
		,-1 AS ContactId
		,-1 AS CustomerAddressId
		,COALESCE(c.CustomerNo,-1) AS CustomerNo
		,CustomerFullName, ShortName
		,'N/A' AS ContactName
		,t.[Description]
		,'N/A' AS [SAPCustomerNumber]
		,'N/A' AS [SAPPayerNumber]
		,c.Id AS [SOLId]
		,COALESCE(rse.[Description], 'N/A') AS [RightsSelection]
		,COALESCE(tse.[Description], 'N/A') AS [TerritorySelection]
		,COALESCE(lse.[Description], 'N/A') AS [LanguageSelection]
		,COALESCE(c.[NumberOfTransmissions], 0) AS [NumberOfTransmissions]
		,CASE
			WHEN c.[NumberOfTransmissions] = -2 THEN 'No Set'
			WHEN c.[NumberOfTransmissions] = -1 THEN 'Unlimited Transmissions'
			WHEN c.[NumberOfTransmissions] = -3 THEN 'Holdback'
			WHEN c.[NumberOfTransmissions] = 2 THEN '2'
			WHEN c.[NumberOfTransmissions] = -4 THEN 'Values'
			WHEN c.[NumberOfTransmissions] = -5 THEN 'Dark Period'
			WHEN c.[NumberOfTransmissions] = -6 THEN 'Exclusive Option to Extend'
			WHEN c.[NumberOfTransmissions] IS NOT NULL THEN CAST(c.[NumberOfTransmissions] AS varchar(30))
			ELSE 'N/A'
		END AS NumberOfTransmissionsName
	FROM [$(MediaDMStaging)].dbo.Customer c
	INNER JOIN [$(MediaDMStaging)].dbo.Territory_lu t ON t.Id = c.ProjectionTerritoryId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[RightsSelectionEx] rse ON c.[RightsSelectionId] = rse.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritorySelectionEx] tse ON c.TerritorySelectionId = tse.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[LanguageSelectionEx] lse ON c.[LanguageSelectionId] = lse.Id
	
	UNION 
	
	SELECT
		-1 AS CustomerId
		,-1 AS ContactId
		,-1 AS CustomerAddressId
		,-1 AS CustomerNo
		,'Unknown' AS CustomerFullName,'Unknown' as ShortName
		,'Unknown' AS ContactName
		,'Unknown' AS ProjectionTerritory
		,'N/A' AS [SAPCustomerNumber]
		,'N/A' AS [SAPPayerNumber]
		,-1 AS [SOLId]
		,'N/A' AS [RightsSelection]
		,'N/A' AS [TerritorySelection]
		,'N/A' AS [LanguageSelection]
		,0 AS [NumberOfTransmissions]
		,'N/A' AS NumberOfTransmissionsName
	) as a
) tt


MERGE 
    dbo.DimCustomerContact t
USING 
    #DimCustomerContact s ON (t.CustomerContactKey = s.CustomerContactKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
	 t.SourceCustomerId = s.SourceCustomerId
	,t.SourceContactId = s.SourceContactId
	,t.SourceCustomerAddressId = s.SourceCustomerAddressId
	,t.CustomerNo = s.CustomerNo
	,t.CustomerName = s.CustomerName
	,t.CustomerShortName = s.CustomerShortName
	,t.ContactName = s.ContactName
	,t.ProjectionTerritory = s.ProjectionTerritory
	,t.SAPCustomerNumber = s.SAPCustomerNumber
	,t.SAPPayerNumber = s.SAPPayerNumber
	,t.SOLId = s.SOLId
	,t.RightsSelection = s.RightsSelection
	,t.TerritorySelection = s.TerritorySelection
	,t.LanguageSelection = s.LanguageSelection
	,t.NumberOfTransmissions = s.NumberOfTransmissions
	,t.NumberOfTransmissionsName = s.NumberOfTransmissionsName
	,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CustomerContactKey, SourceCustomerId, SourceContactId, SourceCustomerAddressId
	,CustomerNo, CustomerName, CustomerShortName, ContactName, ProjectionTerritory, SAPCustomerNumber, SAPPayerNumber, SOLId, 
	RightsSelection, TerritorySelection, LanguageSelection, NumberOfTransmissions,NumberOfTransmissionsName, HashKey)
    VALUES (s.CustomerContactKey, s.SourceCustomerId, s.SourceContactId, s.SourceCustomerAddressId
	,s.CustomerNo, s.CustomerName, s.CustomerShortName, s.ContactName, s.ProjectionTerritory, s.SAPCustomerNumber, s.SAPPayerNumber, s.SOLId, 
	s.RightsSelection, s.TerritorySelection, s.LanguageSelection, s.NumberOfTransmissions, NumberOfTransmissionsName, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimCustomerContact] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimCustomerContact] TO [DataServices]
    AS [dbo];
GO
