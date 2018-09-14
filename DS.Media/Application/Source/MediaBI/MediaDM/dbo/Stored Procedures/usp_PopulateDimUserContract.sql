CREATE PROCEDURE [dbo].[usp_PopulateDimUserContract]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimUserContract') IS NOT NULL DROP TABLE #DimUserContract

SELECT * INTO #DimUserContract FROM dbo.DimUserContract WHERE 1 = 2;

INSERT INTO [#DimUserContract]
           ([UserContractKey]
           ,[BillingCompany]
           ,[LicensorParty]
           ,[IssueSiteStatusId]
		   ,[IssueSite]
           ,[SelectedLicensingCompanies]
		   ,[LegalOnlineContact]
		   ,[HashKey]
		   ,[DeletedOn]
		   )

SELECT
			UserContractKey
           ,BillingCompany
           ,LicensorParty
           ,IssueSiteStatusId
		   ,IssueSite
           ,SelectedLicensingCompanies
		   ,LegalOnlineContact
		   ,dbo.ufn_GetHashDimUserContract(UserContractKey, BillingCompany, LicensorParty, IssueSiteStatusId, IssueSite, SelectedLicensingCompanies, LegalOnlineContact) AS HashKey
		   ,NULL AS DeletedOn

FROM (

SELECT
  dbo.CreateKeyFromSourceID(uislp.Id) AS UserContractKey,
  COALESCE(bc.[Description],'N/A') AS BillingCompany,
  COALESCE(lp.[Description],'N/A') AS LicensorParty,
  iss.StatusId AS IssueSiteStatusId,
  iss.[Description] AS IssueSite,
  CASE WHEN (lp.[Description] LIKE bc.[Description]) THEN lp.[Description]
	     ELSE COALESCE(RTRIM(lp.[Description]) + ' (' + bc.[Description] + ')','N/A') 
       END AS SelectedLicensingCompanies,
  CASE WHEN (u.Firstname <> '') AND (u.Lastname <> '') 
         THEN LTRIM(RTRIM(u.Firstname)) + ' ' + LTRIM(RTRIM(u.Lastname))
	     ELSE COALESCE(LTRIM(RTRIM(u.Firstname)) + LTRIM(RTRIM(u.Lastname)),'N/A') 
       END AS LegalOnlineContact
FROM [$(MediaDMStaging)].[dbo].[IssueSite_lu] AS iss
LEFT JOIN [$(MediaDMStaging)].[dbo].IssueSiteLegalOnlineContact AS isloc ON iss.Id = isloc.IssueSiteId
INNER JOIN [$(MediaDMStaging)].[dbo].[UserIssueSiteLicensorParty] AS uislp WITH (NOLOCK) ON uislp.IssueSiteId = iss.Id
LEFT JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON u.Id = isloc.UserId
INNER JOIN [$(MediaDMStaging)].[dbo].[BillingCompany_lu] AS bc WITH (NOLOCK) ON bc.Id = uislp.BillingCompanyId
INNER JOIN [$(MediaDMStaging)].[dbo].[LicensorParty_lu] AS lp WITH (NOLOCK) ON lp.Id = uislp.LicensorPartyId

UNION ALL

SELECT 
	dbo.CreateKeyFromSourceID(-1) AS UserContractKey,
	'N/A' AS BillingCompany,
	'N/A' AS LicensorParty,
	-1 AS IssueSiteStatusId,
	'N/A' AS IssueSite,
	'N/A' AS SelectedLicensingCompanies,
	'N/A' AS LegalOnlineContact
) tt;


MERGE 
    dbo.DimUserContract t
USING 
    #DimUserContract s ON (t.UserContractKey = s.UserContractKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.UserContractKey = s.UserContractKey
        ,t.BillingCompany = s.BillingCompany
        ,t.LicensorParty = s.LicensorParty
        ,t.IssueSiteStatusId = s.IssueSiteStatusId
		,t.IssueSite = s.IssueSite
        ,t.SelectedLicensingCompanies = s.SelectedLicensingCompanies
		,t.LegalOnlineContact = s.LegalOnlineContact
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (UserContractKey, BillingCompany, LicensorParty, IssueSiteStatusId, IssueSite, SelectedLicensingCompanies, LegalOnlineContact, HashKey)
    VALUES (s.UserContractKey, s.BillingCompany, s.LicensorParty, s.IssueSiteStatusId, s.IssueSite, s.SelectedLicensingCompanies, s.LegalOnlineContact, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimUserContract] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimUserContract] TO [DataServices]
    AS [dbo];
GO
