CREATE PROCEDURE [dbo].[usp_PopulateDimProperty]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

DROP TABLE IF EXISTS #DimProperty


/* Create list of months */
IF OBJECT_ID('tempdb..#tempMonths') IS NOT NULL drop table #tempMonths
;WITH T([DATE]) AS
(
	SELECT GETDATE() as [DATE]
	UNION ALL
	SELECT DATEADD(DAY,1, T.[DATE])
	FROM T WHERE T.[DATE] > CAST('1900-01-01' as DATE) AND T.[DATE] < DATEADD(YEAR, 1, GETDATE())
)
SELECT DISTINCT DATENAME(MONTH, [DATE]) AS [MonthName], DATEPART(MONTH,[DATE]) AS [MonthNumber] 
INTO #tempMonths
FROM T
ORDER BY [MonthNumber]
OPTION (MAXRECURSION 370);

/* commission from MDS */
IF OBJECT_ID('tempdb..#TempCommission') IS NOT NULL drop table #TempCommission
SELECT
	DISTINCT
	co.Code
	,co.[Sales Category_Name]
	,co.Abbreviation
	,co.Commission 
	,co.Comment
	INTO #TempCommission
FROM [$(MediaDMStaging)].[dbo].MDS_Commission co
CREATE CLUSTERED INDEX CI_COmission ON #TempCommission (Code)

/* Preparing list of properties for flag IsReplayReport*/
IF OBJECT_ID('tempdb..#TempReplayReportProperties') IS NOT NULL drop table #TempReplayReportProperties
SELECT 
	p.[Id] AS ProductId,
	p.OPANumber,
	COALESCE(op.OmitException, 0) AS OmitException
INTO #TempReplayReportProperties
FROM [$(MediaDMStaging)].[dbo].[Product] p
LEFT JOIN [$(MediaDMStaging)].dbo.AreaOfBusinessSuffix_lu absr ON absr.Id = p.AreaOfBusinessSuffixId
LEFT JOIN 
(
	SELECT 
		[Id], 1 AS OmitException
	FROM [$(MediaDMStaging)].[dbo].[Product] p
	WHERE p.OPANumber IN ('38829281','34601881','34601981','34602081','34602381','34602481','34602581','34733481','34733581','36292281','
									 36798381','37632281','37874981','38162581','38772481','39378181','39643881','39643981','39826381','44138781', 
									   '39826381') -- Ticket #161
) op ON p.[Id]= op.[Id]
WHERE 
	(
		absr.AreaOfBusinessId = 13 -- Archive
		AND IsNull(p.OPANumberT, p.OPANumber) NOT IN ('39662581','39834481','39841381','44042181','44433081') -- These were specified in tickets #126
	)
	OR -- OPA numbers from Comment no.5 from SOL ticket #87, #133,#126
	(
		p.OPANumber IN  
			('31651675',' 38391220',' 38391220',' 38993275') 
	)

CREATE CLUSTERED INDEX CI_PropertyKey ON #TempReplayReportProperties ([ProductId])

/* Clients under representation */
DROP TABLE IF EXISTS #clientunderrepresentation

SELECT
	DISTINCT 
	pra.ProductId
	,c.ClientFullName
	,c.ClientName
	,c.ClientNo
	,te.[Description] AS ClientCountry
	,c.IsIMGClient
	,Adr.Line1 +  ', ' + 
	CASE ISNULL(Adr.Line2,'') WHEN '' THEN '' ELSE Adr.Line2 + ', ' END + 
	CASE ISNULL(Adr.Line3,'') WHEN '' THEN '' ELSE Adr.Line3 + ', ' END + 
	CASE ISNULL(Adr.Line6,'') WHEN '' THEN '' ELSE Adr.Line6 + ', ' END +
	CASE ISNULL(tr.Description,'') WHEN '' THEN '' ELSE tr.Description + ', ' END + 
	CASE ISNULL(te.Description,'') WHEN '' THEN '' ELSE te.Description + ' ' END AS ClientAddress
	,COUNT(*) OVER (PARTITION BY pra.ProductId ) AS pocet
	,ROW_NUMBER() OVER (PARTITION BY pra.ProductId ORDER BY cra.ClientId) AS ChoseOne
	INTO #clientunderrepresentation
FROM [$(MediaDMStaging)].[dbo].ProductRepresentationAgreement pra 
INNER JOIN [$(MediaDMStaging)].[dbo].RepresentationAgreement ra ON pra.RepresentationAgreementId = ra.Id
INNER JOIN [$(MediaDMStaging)].[dbo].ClientRepresentationAgreement cra ON cra.RepresentationAgreementId = ra.Id 
INNER JOIN [$(MediaDMStaging)].[dbo].Client c ON cra.ClientId = c.Id
INNER JOIN [$(MediaDMStaging)].[dbo].ClientAddress adr ON c.Id = adr.ClientId
INNER JOIN [$(MediaDMStaging)].[dbo].Territory_lu te  ON adr.TerritoryId = te.Id
LEFT JOIN [$(MediaDMStaging)].[dbo].TerritoryRegion_lu tr WITH (NOLOCK) ON Adr.TerritoryRegionId = tr.Id
WHERE   
	(cra.StatusId = 1) 
	AND (ra.StatusId = 1) 
	AND (pra.StatusId = 1)
	AND (adr.StatusId = 1)
	AND CategoryBitSum & 32 > 0


SELECT 
	 PropertyKey
	,SourceProductId
	,OPANumber
	,OPANumberT
	,PropertyName
	,ShortName
	,GenericName
	,AreaOfBusiness
	,AreaOfBusinessT
	,AreaOfBusinessSuffix
	,AreaOfBusinessSuffixT
	,PropertyCategoryType
	,PropertyCategory
	,SubjectCategory
	,BillingCompany
	,IssueSite
	,AccountantResponsible
	,ExecResponsible
	,ProjectionYear
	,IncomeProjectionDate
	,IncomeProjectionDateINT
	,SalesCategoryMDS
	,AbbreviationMDS
	,CommissionMDS
	,CommissionNumMDS
	,CommentMDS
	,LegalContact
	,InvoiceCategory
	,HeadOfBusinessUnit
	,HeadOfSport
	,IsReplayReport
	,IsOmitException
	,ClientCountry
	,ClientName
	,ClientNo
	,Licensor
	,ContractingParty
	,BroadcastDateFrom
	,BroadcastDateTo
	,ParentPropertyKey
	,IsIMGClient
	,ClientAddress
	,ReportingType
	,PremiereDate
	,AvailabilityDate
	,CreatedDate
    ,CreatedBy
    ,UpdatedDate
    ,UpdatedBy
    ,Comment
	,CommentCreatedBy
	,CommentCreatedDate
	,ImgAsAuthorisedSignatory
	,LicensorInDeal
	,IncludeInOutputDeal
	,SellAtRisk
	,LegalOnlineNo
	,ContractStatus
    ,dbo.ufn_GetHashDimProperty(
		PropertyKey, SourceProductId, OPANumber, OPANumberT, PropertyName, ShortName, GenericName
		,AreaOfBusiness, AreaOfBusinessT, AreaOfBusinessSuffix, AreaOfBusinessSuffixT
		,PropertyCategoryType, PropertyCategory, SubjectCategory, BillingCompany, IssueSite, AccountantResponsible,ExecResponsible
		,ProjectionYear, IncomeProjectionDate, IncomeProjectionDateINT, [SalesCategoryMDS], [AbbreviationMDS], [CommissionMDS], [CommissionNumMDS]
		,CommentMDS, LegalContact, InvoiceCategory, HeadOfBusinessUnit, HeadOfSport, IsReplayReport, IsOmitException,ClientCountry, ClientName, ClientNo
		,Licensor, ContractingParty, BroadcastDateFrom, BroadcastDateTo, IsIMGClient, ClientAddress, ParentPropertyKey, ReportingType, PremiereDate, AvailabilityDate
		,CreatedDate ,CreatedBy ,UpdatedDate ,UpdatedBy ,Comment, CommentCreatedBy, CommentCreatedDate, ImgAsAuthorisedSignatory ,LicensorInDeal ,IncludeInOutputDeal
		,SellAtRisk, LegalOnlineNo, ContractStatus
	) AS HashKey 
    ,NULL AS DeletedOn
	INTO #DimProperty
FROM (
	SELECT 
		dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey
		,p.Id AS SourceProductId
		,p.OPANumber
		,COALESCE(p.OPANumberT, rrp.OPANumber, 'N/A') AS OPANumberT
		,p.[Description] AS PropertyName
		,p.ShortDesc AS ShortName
		,p.GenericName
		,abr.[Description] AS AreaOfBusiness
		,COALESCE(abt.[Description], 'N/A') AS AreaOfBusinessT
		,absr.[Description] AS AreaOfBusinessSuffix
		,COALESCE(abst.[Description], 'N/A') AS AreaOfBusinessSuffixT
		,COALESCE(pct.[Description], 'N/A') AS PropertyCategoryType
		,COALESCE(pc.[Description], 'N/A') AS PropertyCategory
		,COALESCE(sc.[Description], 'N/A') AS SubjectCategory
		,COALESCE(bc.[Description], 'N/A') AS BillingCompany
		,COALESCE(CASE
			WHEN iss.[Description] = 'BLANK' THEN 'N/A'
			ELSE iss.[Description] 
		END, 'N/A') AS IssueSite
		,COALESCE(ar.Firstname + ' ' +  ar.Lastname, 'N/A') AS AccountantResponsible
		,COALESCE(er.Firstname + ' ' +  er.Lastname, 'N/A') AS ExecResponsible
		,COALESCE(p.[ProjectionYear], 'N/A') AS ProjectionYear
		,CASE 
			WHEN COALESCE(p.[IncomeProjectionMonth], -1)  = 0 THEN 'Series'
			WHEN COALESCE(p.[IncomeProjectionMonth], -1) > 0 THEN
				(SELECT [MonthName] FROM #tempMonths WHERE MonthNumber = p.[IncomeProjectionMonth])
			ELSE 'N/A'
		END AS IncomeProjectionDate
		,COALESCE(p.[IncomeProjectionMonth], -1) AS IncomeProjectionDateINT
		,COALESCE(co.[Sales Category_Name], 'N/A') AS [SalesCategoryMDS] 
		,COALESCE(co.Abbreviation, 'N/A') AS [AbbreviationMDS] 
		,COALESCE(CAST(co.Commission AS VARCHAR(10)) + '%', 'N/A') AS [CommissionMDS] 
		,COALESCE(co.Commission, 0) AS [CommissionNumMDS]
		,COALESCE(co.Comment, 'N/A') AS [CommentMDS]
		,COALESCE(lc.Firstname + ' ' +  lc.Lastname, 'N/A') AS LegalContact
		,COALESCE(ic.[Description], 'N/A') AS InvoiceCategory
		,COALESCE(hbu.Firstname + ' ' +  hbu.Lastname, 'N/A') AS HeadOfBusinessUnit
		,COALESCE(hs.Firstname + ' ' +  hs.Lastname, 'N/A') AS HeadOfSport
		,CASE WHEN rrp.ProductId IS NOT NULL THEN 'Yes' ELSE 'No' END AS IsReplayReport
		,CASE WHEN rrp.OmitException = 1 THEN 'Yes' WHEN rrp.OmitException = 0 THEN 'No' ELSE 'N/A' END As IsOmitException
		,COALESCE( 
			STUFF(
				(SELECT CAST(', ' AS varchar(500)) + b.ClientCountry 
					FROM #clientunderrepresentation as b 
					WHERE b.ProductId = p.Id
					FOR XML PATH(''), TYPE 
				).value('.', 'varchar(500)'),1, 1,''
			),'N/A' 
		) AS ClientCountry 
		,COALESCE( 
			STUFF(
				(SELECT CAST(', ' AS varchar(500)) + b.ClientName 
					FROM #clientunderrepresentation as b 
					WHERE b.ProductId = p.Id
					FOR XML PATH(''), TYPE 
				).value('.', 'varchar(500)'),1, 1,''
			),'N/A'
		) AS ClientName 
		,COALESCE(
			STUFF(
				(SELECT CAST(', ' AS varchar(500)) + CAST(b.ClientNo AS VARCHAR)
					FROM #clientunderrepresentation as b 
					WHERE b.ProductId = p.Id
					FOR XML PATH(''), TYPE
				).value('.', 'varchar(500)'),1, 1,''
			), 'N/A'
		) AS ClientNo 
		,COALESCE(l.[Description],'N/A') AS Licensor
		,COALESCE(cc.[Description],'N/A') AS ContractingParty
		,p.StartDate AS BroadcastDateFrom
		,p.EndDate AS BroadcastDateTo 
		,COALESCE( 
			STUFF(
				(SELECT CAST(', ' AS varchar(31)) + COALESCE(CASE WHEN b.IsIMGClient = 1 THEN 'Yes' WHEN b.IsIMGClient = 0 THEN 'No' END,'N/A')
					FROM #clientunderrepresentation as b 
					WHERE b.ProductId = p.Id
					FOR XML PATH(''), TYPE 
				).value('.', 'varchar(31)'),1, 1,''
			),'N/A' 
		) AS IsIMGClient
		,COALESCE( 
			STUFF(
				(SELECT CAST('| ' AS varchar(2479)) + b.ClientAddress
					FROM #clientunderrepresentation as b 
					WHERE b.ProductId = p.Id
					FOR XML PATH(''), TYPE 
				).value('.', 'varchar(2479)'),1, 1,''
			),'N/A' 
		) AS ClientAddress
		,COALESCE(rt.Description,'N/A') AS ReportingType
		,p.PremiereDate AS PremiereDate
		,p.AvailabilityDate AS AvailabilityDate

		/*,COALESCE(CASE
			WHEN cur.IsIMGClient = 1 THEN 'Yes'
			WHEN cur.IsIMGClient = 0 THEN 'No' 
		 END, 'N/A') AS IsIMGClient
		,COALESCE(cur.ClientAddress, 'N/A') AS ClientAddress */
		,p.CreatedDate
		,COALESCE((SELECT Firstname + ' ' +  Lastname FROM [$(MediaDMStaging)].[dbo].[User] WHERE Id = p.CreatedBy), 'N/A') AS CreatedBy
		,p.UpdatedDate
		,COALESCE((SELECT Firstname + ' ' +  Lastname FROM [$(MediaDMStaging)].[dbo].[User] WHERE Id = p.UpdatedBy), 'N/A') AS UpdatedBy
		,COALESCE((SELECT TOP 1  LEFT([Description], 600) FROM [$(MediaDMStaging)].[dbo].[ProductComment] WHERE ProductId = p.Id Order by Id DESC ), 'N/A') AS Comment
		,COALESCE((SELECT TOP 1  u.Firstname + ' ' +  u.Lastname FROM [$(MediaDMStaging)].[dbo].[ProductComment] pc 
																 LEFT JOIN [$(MediaDMStaging)].[dbo].[User] u ON pc.CreatedBy = u.Id  
																 WHERE ProductId = p.Id Order by pc.Id DESC ), 'N/A') AS CommentCreatedBy
		,COALESCE((SELECT TOP 1  [CreatedDate] FROM [$(MediaDMStaging)].[dbo].[ProductComment] WHERE ProductId = p.Id Order by Id DESC ), '1900-01-01') AS CommentCreatedDate
		,CASE WHEN p.[ImgAsAuthorisedSignatory] = 1 THEN 'Yes' WHEN p.[ImgAsAuthorisedSignatory] = 0 THEN 'No' ELSE 'N/A' END AS ImgAsAuthorisedSignatory
		,LTRIM(CASE 
			WHEN p.[ImgAsAuthorisedSignatory] = 1 THEN COALESCE(bc.[Description], 'N/A')
			WHEN p.[ImgAsAuthorisedSignatory] = 0 THEN 
					COALESCE( 
						STUFF(
							(SELECT CAST(', ' AS varchar(500)) + b.ClientName 
								FROM #clientunderrepresentation as b 
								WHERE b.ProductId = p.Id
								FOR XML PATH(''), TYPE 
							).value('.', 'varchar(300)'),1, 1,''
						),'N/A') 
			ELSE 'N/A'
		END) AS [LicensorInDeal]
		,CASE WHEN p.[IncludeInOutputDeal] = 1 THEN 'Yes' WHEN p.[IncludeInOutputDeal] = 0 THEN 'No' ELSE 'N/A' END AS [IncludeInOutputDeal]
		,CASE WHEN p.[SellAtRisk] = 1 THEN 'Yes' WHEN p.[SellAtRisk] = 0 THEN 'No' ELSE 'N/A' END AS [SellAtRisk]
		,COALESCE(p.[LegalOnlineNo],-1) AS [LegalOnlineNo]
		,COALESCE((Select [Description] FROM [$(MediaDMStaging)].[dbo].ContractStatus_lu cs WHERE cs.Id = p.[ContractStatus] ), 'N/A') AS [ContractStatus]
		,dbo.CreateKeyFromSourceID(p.ParentId) AS ParentPropertyKey
	FROM [$(MediaDMStaging)].dbo.Product p
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = p.SubjectCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.BillingCompany_lu bc ON bc.Id = p.BillingCompanyId
	LEFT JOIN [$(MediaDMStaging)].dbo.ProductCategoryTypeIndex_lu pcti ON pcti.Id = p.ProductCategoryTypeIndexId
	LEFT JOIN [$(MediaDMStaging)].dbo.ProductCategoryType_lu pct ON pct.Id = pcti.ProductCategoryTypeId
	LEFT JOIN [$(MediaDMStaging)].dbo.ProductCategory_lu pc ON pc.Id = pcti.ProductCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.AreaOfBusinessSuffix_lu absr ON absr.Id = p.AreaOfBusinessSuffixId
	LEFT JOIN [$(MediaDMStaging)].dbo.AreaOfBusiness_lu abr ON abr.Id = absr.AreaOfBusinessId
	LEFT JOIN [$(MediaDMStaging)].dbo.AreaOfBusinessSuffix_lu abst ON abst.Id = p.AreaOfBusinessSuffixTId
	LEFT JOIN [$(MediaDMStaging)].dbo.AreaOfBusiness_lu abt ON abt.Id = abst.AreaOfBusinessId
	LEFT JOIN [$(MediaDMStaging)].dbo.IssueSite_lu iss ON iss.Id = bc.IssueSiteId
	LEFT JOIN [$(MediaDMStaging)].dbo.Licensor_lu l on l.Id = p.LicensorId
	LEFT JOIN [$(MediaDMStaging)].dbo.ContractIssueCategory_lu cc on cc.Id = p.ContractIssueCategoryId
	LEFT JOIN [$(MediaDMStaging)].dbo.ReportingType_lu rt on rt.Id = p.ReportingTypeId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] AS er ON p.ExecResponsibleId = er.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] AS ar ON p.AccountantResponsibleId = ar.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] AS lc ON p.LegalContactId = lc.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] AS hbu ON p.HeadOfBusinessUnitId = hbu.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] AS hs ON p.HeadOfSportId = hs.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[InvoiceCategory_lu] AS ic ON p.InvoiceCategoryId = ic.Id
 	LEFT JOIN #TempCommission co ON p.OPANumber = co.Code
	LEFT JOIN #TempReplayReportProperties AS rrp ON p.Id = rrp.ProductId

	UNION ALL

	SELECT 
		dbo.CreateKeyFromSourceID(-1) AS PropertyKey
		,-1 AS SourceProductId
		,'N/A' AS OPANumber
		,'N/A' AS OPANumberT
		,'N/A' AS PropertyName
		,'N/A' AS ShortName
		,'N/A' AS GenericName
		,'N/A' AS AreaOfBusiness
		,'N/A' AS AreaOfBusinessT
		,'N/A' AS AreaOfBusinessSuffix
		,'N/A' AS AreaOfBusinessSuffixT
		,'N/A' AS PropertyCategoryType
		,'N/A' AS PropertyCategory
		,'N/A' AS SubjectCategory
		,'N/A' AS BillingCompany
		,'N/A' AS IssueSite
		,'N/A' AS AccountantResponsible
		,'N/A' AS ExecResponsible
		,'N/A' AS ProjectionYear
		,'N/A' AS IncomeProjectionDate
		,-1 AS IncomeProjectionDateINT
		,'N/A' AS [SalesCategoryMDS] 
		,'N/A' AS [AbbreviationMDS] 
		,'N/A' AS [CommissionMDS] 
		,0 AS [CommissionNumMDS]
		,'N/A' AS [CommentMDS]
		,'N/A' AS LegalContact
		,'N/A' AS InvoiceCategory
		,'N/A' AS HeadOfBusinessUnit
		,'N/A' AS HeadOfSport
		,'N/A' AS IsReplayReport
		,'N/A' AS IsOmitException
		,'N/A' AS ClientCountry 
		,'N/A' AS ClientName 
		,'N/A' AS ClientNo 
		,'N/A' AS Licensor
		,'N/A' AS ContractingParty
		,NULL AS BroadcastDateFrom
		,NULL AS BroadcastDateTo 
		,'N/A' AS IsIMGClient
		,'N/A' AS ClientAddress
		,'N/A' AS ReportingType
		,'1900-01-01' AS PremiereDate
		,'1900-01-01' AS AvailabilityDate
		,'1900-01-01' AS CreatedDate
		,'N/A' AS CreatedBy
		,'1900-01-01' AS UpdatedDate
		,'N/A' AS UpdatedBy
		,'N/A' AS Comment
		,'N/A' AS CommentCreatedBy
		,'1900-01-01' AS CommentCreatedDate
		,'N/A' AS ImgAsAuthorisedSignatory
		,'N/A' AS LicensorInDeal
		,'N/A' AS IncludeInOutputDeal
		,'N/A' AS SellAtRisk
		,-1 AS LegalOnlineNo
		,'N/A' AS ContractStatus
		,dbo.CreateKeyFromSourceID(-1) AS ParentPropertyKey
) tt;
CREATE CLUSTERED INDEX IC_PropertyPropertyKey ON #DimProperty(PropertyKey);

MERGE 
    dbo.DimProperty t
USING 
    #DimProperty s ON (t.PropertyKey = s.PropertyKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.PropertyKey = s.PropertyKey
		,t.SourceProductId = s.SourceProductId
		,t.OPANumber = s.OPANumber
		,t.OPANumberT = s.OPANumberT
		,t.PropertyName = s.PropertyName
		,t.ShortName = s.ShortName
		,t.GenericName = s.GenericName
		,t.AreaOfBusiness = s.AreaOfBusiness
		,t.AreaOfBusinessT = s.AreaOfBusinessT
		,t.AreaOfBusinessSuffix = s.AreaOfBusinessSuffix
		,t.AreaOfBusinessSuffixT = s.AreaOfBusinessSuffixT
		,t.PropertyCategoryType = s.PropertyCategoryType
		,t.PropertyCategory = s.PropertyCategory
		,t.SubjectCategory = s.SubjectCategory
		,t.BillingCompany = s.BillingCompany
		,t.IssueSite = s.IssueSite
		,t.AccountantResponsible = s.AccountantResponsible
		,t.ExecResponsible = s.ExecResponsible
		,t.ProjectionYear = s.ProjectionYear
		,t.IncomeProjectionDate = s.IncomeProjectionDate
		,t.IncomeProjectionDateINT = s.IncomeProjectionDateINT
		,t.SalesCategoryMDS = s.SalesCategoryMDS
		,t.AbbreviationMDS = s.AbbreviationMDS
		,t.CommissionMDS = s.CommissionMDS
		,t.CommissionNumMDS = s.CommissionNumMDS
		,t.CommentMDS = s.CommentMDS
		,t.LegalContact = s.LegalContact
		,t.InvoiceCategory = s.InvoiceCategory
		,t.HeadOfBusinessUnit = s.HeadOfBusinessUnit
		,t.HeadOfSport = s.HeadOfSport
		,t.IsReplayReport = s.IsReplayReport
		,t.IsOmitException = s.IsOmitException
		,t.ClientCountry = s.ClientCountry
		,t.ClientName = s.ClientName
		,t.ClientNo = s.ClientNo
		,t.[Licensor] = s.Licensor
		,t.[ContractingParty] = s.[ContractingParty]
		,t.[BroadcastDateFrom] = s.[BroadcastDateFrom]
		,t.[BroadcastDateTo] = s.[BroadcastDateTo]
		,t.ParentPropertyKey = s.ParentPropertyKey
		,t.IsIMGClient = s.IsIMGClient
		,t.ClientAddress = s.ClientAddress
		,t.ReportingType = s.ReportingType
		,t.PremiereDate = s.PremiereDate
		,t.AvailabilityDate = s.AvailabilityDate
		,t.CreatedDate = s.CreatedDate
		,t.CreatedBy = s.CreatedBy
		,t.UpdatedDate = s.UpdatedDate
		,t.UpdatedBy = s.UpdatedBy
		,t.Comment = s.Comment
		,t.CommentCreatedBy = s.CommentCreatedBy
		,t.CommentCreatedDate = s.CommentCreatedDate
		,t.ImgAsAuthorisedSignatory = s.ImgAsAuthorisedSignatory
		,t.LicensorInDeal = s.LicensorInDeal
		,t.IncludeInOutputDeal = s.IncludeInOutputDeal
		,t.SellAtRisk = s.SellAtRisk
		,t.LegalOnlineNo = s.LegalOnlineNo
		,t.ContractStatus = s.ContractStatus
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PropertyKey, SourceProductId, OPANumber, OPANumberT, PropertyName, ShortName, GenericName
	,AreaOfBusiness, AreaOfBusinessT, AreaOfBusinessSuffix, AreaOfBusinessSuffixT
	,PropertyCategoryType, PropertyCategory, SubjectCategory, BillingCompany, IssueSite, AccountantResponsible,ExecResponsible
	,ProjectionYear, IncomeProjectionDate, IncomeProjectionDateINT, [SalesCategoryMDS], [AbbreviationMDS], [CommissionMDS], [CommissionNumMDS]
	,CommentMDS, LegalContact, InvoiceCategory,HeadOfBusinessUnit, HeadOfSport,IsReplayReport, IsOmitException, ClientCountry, ClientName, ClientNo
	,Licensor, ContractingParty, BroadcastDateFrom, BroadcastDateTo, ParentPropertyKey, IsIMGClient, ClientAddress, ReportingType, PremiereDate, AvailabilityDate
	,CreatedDate, CreatedBy, UpdatedDate, UpdatedBy, Comment, CommentCreatedBy, CommentCreatedDate, ImgAsAuthorisedSignatory, LicensorInDeal, IncludeInOutputDeal
	,SellAtRisk, LegalOnlineNo, ContractStatus, HashKey)
    VALUES (s.PropertyKey, s.SourceProductId, s.OPANumber, s.OPANumberT, s.PropertyName, s.ShortName, s.GenericName
	,s.AreaOfBusiness, s.AreaOfBusinessT, s.AreaOfBusinessSuffix, s.AreaOfBusinessSuffixT
	,s.PropertyCategoryType, s.PropertyCategory, s.SubjectCategory, s.BillingCompany, s.IssueSite, s.AccountantResponsible, s.ExecResponsible
	,s.ProjectionYear, s.IncomeProjectionDate, s.IncomeProjectionDateINT, s.SalesCategoryMDS, s.AbbreviationMDS, s.CommissionMDS, s.CommissionNumMDS
	,s.CommentMDS, s.LegalContact, s.InvoiceCategory,s.HeadOfBusinessUnit, s.HeadOfSport,s.IsReplayReport, s.IsOmitException,s.ClientCountry, s.ClientName, s.ClientNo
	,s.Licensor, s.ContractingParty, s.BroadcastDateFrom, s.BroadcastDateTo, s.ParentPropertyKey, s.IsIMGClient, s.ClientAddress, s.ReportingType
	,s.PremiereDate, s.AvailabilityDate, s.CreatedDate, s.CreatedBy, s.UpdatedDate, s.UpdatedBy, s.Comment, s.CommentCreatedBy, s.CommentCreatedDate
	,s.ImgAsAuthorisedSignatory, s.LicensorInDeal, s.IncludeInOutputDeal, s.SellAtRisk, s.LegalOnlineNo, s.ContractStatus, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0;
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimProperty] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimProperty] TO [DataServices]
    AS [dbo];
GO

