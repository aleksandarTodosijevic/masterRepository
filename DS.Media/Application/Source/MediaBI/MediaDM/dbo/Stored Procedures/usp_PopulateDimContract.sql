
CREATE PROCEDURE [dbo].[usp_PopulateDimContract]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimContract') IS NOT NULL DROP TABLE #DimContract

-- Legal online contacts
IF OBJECT_ID('tempdb..#tempLegalOnlineContacts') IS NOT NULL DROP TABLE #tempLegalOnlineContacts

SELECT * INTO #DimContract FROM dbo.DimContract WHERE 1 = 2

CREATE CLUSTERED INDEX IC_ContractContractKey ON #DimContract(ContractKey);


SELECT DISTINCT
	iss.Id AS IssueSiteId, 
	CASE WHEN (u.Firstname <> '') AND (u.Lastname <> '') 
		THEN LTRIM(RTRIM(u.Firstname)) + ' ' + LTRIM(RTRIM(u.Lastname))
		ELSE LTRIM(RTRIM(u.Firstname)) + LTRIM(RTRIM(u.Lastname)) 
	END AS LegalOnlineContact ,
	iss.StatusId
	INTO #tempLegalOnlineContacts
FROM 
	[$(MediaDMStaging)].[dbo].[IssueSite_lu] AS iss 
	INNER JOIN [$(MediaDMStaging)].[dbo].[IssueSiteLegalOnlineContact] AS isslol ON isslol.IssueSiteId = iss.Id
	INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON u.Id = isslol.UserId

INSERT INTO #DimContract

SELECT 
	ContractKey
	,ContractDescription
	,AgreementType
	,AgreementBy
	,ContractType
	,LicensorParty
	,LegalOnline
	,LegalContractStatus
	,Licensor
	,ContractText
	,ContractInstructions
	,IssueSite
	,City
	,Region
	,Country
	,LegalOnlineContact
	,IssueSiteId
    ,dbo.ufn_GetHashDimContract(ContractKey, ContractDescription, AgreementType, AgreementBy, ContractType, LicensorParty, LegalOnline, LegalContractStatus, Licensor, ContractText,
								ContractInstructions, IssueSite, City, Region, Country, LegalOnlineContact, IssueSiteId) AS HashKey
    ,NULL AS DeletedOn
FROM (

SELECT
	dbo.CreateKeyFromSourceID(c.[Id]) as ContractKey,
	c.[Description] + CASE WHEN c.[StatusId] = 2 THEN ' (Cancelled)' ELSE '' END as ContractDescription,
	COALESCE(agt.[Description], 'N/A') AS AgreementType,
	COALESCE(cicat.[Description], 'N/A') AS AgreementBy,
	COALESCE(cType.[Description], 'N/A') AS ContractType,
	COALESCE(clt.[ClientName], 'N/A') AS LicensorParty,
	COALESCE(c.[LegalContractId], -1) AS LegalOnline,
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].[dbo].ContractStatus_lu WHERE Id = c.ContractStatusId), 'N/A') AS LegalContractStatus,
	COALESCE(l.[Description], 'N/A') AS Licensor,
	COALESCE(c.[ContractText], 'N/A') AS ContractText,
	COALESCE(
		CASE WHEN c.ContractInstructions = ' ' THEN NULL ELSE c.ContractInstructions  END
	, 'N/A') AS ContractInstructions
	,COALESCE(iss.[Description], 'N/A') AS IssueSite
	,COALESCE(ca.[Line3], 'N/A') AS City
	,COALESCE(tr.[Description], 'N/A') AS Region
	,COALESCE(te.[Description], 'N/A') AS Country
	,COALESCE(loc.LegalOnlineContact ,'N/A') AS LegalOnlineContact
	,COALESCE(iss.Id, -1) AS IssueSiteId
FROM
	[$(MediaDMStaging)].[dbo].[Contract] c
	LEFT JOIN [$(MediaDMStaging)].[dbo].[ContractIssueCategory_lu] cicat ON cicat.Id = c.ContractIssueCategoryId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[ContractType_lu] cType ON cType.Id = c.ContractTypeId
	INNER JOIN [$(MediaDMStaging)].[dbo].[Client] clt ON clt.Id = c.ClientId
	INNER JOIN [$(MediaDMStaging)].[dbo].[AgreementType_lu] agt ON agt.Id = c.AgreementTypeId
	INNER JOIN [$(MediaDMStaging)].[dbo].[Licensor_lu] l ON l.Id = c.LicensorId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[IssueSite_lu] AS iss ON iss.Id = c.IssueSiteId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[CustomerAddress] AS ca ON c.CustomerAddressId = ca.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritoryRegion_lu] AS tr ON ca.TerritoryRegionId = tr.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Territory_lu] AS te ON ca.TerritoryId = te.Id
	LEFT JOIN #tempLegalOnlineContacts AS loc ON c.IssueSiteId = loc.IssueSiteId
	
UNION ALL

SELECT 
	dbo.CreateKeyFromSourceID(-1) as ContractKey,
	'N/A' AS ContractDescription,
	'N/A' AS AgreementType,
	'N/A' AS AgreementBy,
	'N/A' AS ContractType,
	'N/A' AS LicensorParty,
	-1 AS LegalOnline,
	'N/A' AS LegalContractStatus,
	'N/A' AS Licensor,
	'N/A' AS ContractText,
	'N/A' AS ContractInstructions,
	'N/A' AS IssueSite,
	'N/A' AS City,
	'N/A' AS Region,
	'N/A' AS Country,
	'N/A' AS LegalOnlineContact,
	-1 AS IssueSiteId

) tt


MERGE 
    dbo.DimContract t
USING 
    #DimContract s ON (t.ContractKey = s.ContractKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
	 t.ContractKey = s.ContractKey
	,t.ContractDescription = s.ContractDescription
	,t.AgreementType = s.AgreementType
	,t.AgreementBy = s.AgreementBy
	,t.ContractType = s.ContractType
	,t.LicensorParty = s.LicensorParty
	,t.LegalOnline = s.LegalOnline
	,t.LegalContractStatus = s.LegalContractStatus
	,t.Licensor = s.Licensor
	,t.ContractText = s.ContractText
	,t.ContractInstructions = s.ContractInstructions
	,t.IssueSite = s.IssueSite
	,t.City = s.City
	,t.Region = s.Region
	,t.Country = s.Country
	,t.LegalOnlineContact = s.LegalOnlineContact
	,t.IssueSiteId = s.IssueSiteId
	,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ContractKey, ContractDescription, AgreementType, AgreementBy, ContractType, LicensorParty, LegalOnline, LegalContractStatus, Licensor, ContractText,
								ContractInstructions, IssueSite, City, Region, Country, LegalOnlineContact, IssueSiteId, HashKey)
    VALUES (s.ContractKey, s.ContractDescription, s.AgreementType, s.AgreementBy, s.ContractType, s.LicensorParty, s.LegalOnline, s.LegalContractStatus, s.Licensor, s.ContractText,
								s.ContractInstructions, s.IssueSite, s.City, s.Region, s.Country, s.LegalOnlineContact, s.IssueSiteId, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimContract] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimContract] TO [DataServices]
    AS [dbo];
GO
