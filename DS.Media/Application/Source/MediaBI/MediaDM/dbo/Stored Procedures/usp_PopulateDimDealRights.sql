CREATE PROCEDURE [dbo].[usp_PopulateDimDealRights]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimDealRights') IS NOT NULL DROP TABLE #DimDealRights

SELECT * INTO #DimDealRights FROM dbo.DimDealRights WHERE 1 = 2;


INSERT INTO #DimDealRights 
  (DealRightsKey, SourceDealRightsId, DealRightsDescription, Exclusive, TerritoryDescription, LanguageDescription, 
	LicenseStart, LicenseEnd, NumberOfTransmissions, NumberOfTransmissionsName, InPerpetuity, LicenseDuration, HashKey, DeletedOn)

SELECT
    DealRightsKey
   ,SourceDealRightsId
   ,DealRightsDescription
   ,Exclusive
   ,TerritoryDescription
   ,LanguageDescription
   ,LicenseStart
   ,LicenseEnd
   ,NumberOfTransmissions
   ,NumberOfTransmissionsName
   ,InPerpetuity
   ,LicenseDuration
   ,dbo.ufn_GetHashDimDealRights(DealRightsKey, SourceDealRightsId, DealRightsDescription, Exclusive, TerritoryDescription, LanguageDescription, 
	LicenseStart, LicenseEnd, NumberOfTransmissions, NumberOfTransmissionsName, InPerpetuity, LicenseDuration) AS HashKey
   ,NULL AS DeletedOn
FROM (

SELECT
	dbo.CreateKeyFromSourceID(rd.Id) AS DealRightsKey
	,rd.Id AS SourceDealRightsId
	,rs.Description AS DealRightsDescription
	,CASE rd.Exclusive
		WHEN 1 THEN 'Yes'
		WHEN 0 THEN 'No'
		ELSE 'N/A'
	END AS Exclusive
	,ts.Description AS TerritoryDescription
	,ls.Description AS LanguageDescription
	,rd.LicenseStartDate AS LicenseStart
	,rd.LicenseEndDate AS LicenseEnd
	,COALESCE(rd.NumberOfTransmissions,0) AS NumberOfTransmissions
	,CASE
		WHEN rd.NumberOfTransmissions = -2 THEN 'No Set'
		WHEN rd.NumberOfTransmissions = -1 THEN 'Unlimited Transmissions'
		WHEN rd.NumberOfTransmissions = -3 THEN 'Holdback'
		WHEN rd.NumberOfTransmissions = 2 THEN '2'
		WHEN rd.NumberOfTransmissions = -4 THEN 'Values'
		WHEN rd.NumberOfTransmissions = -5 THEN 'Dark Period'
		WHEN rd.NumberOfTransmissions = -6 THEN 'Exclusive Option to Extend'
		WHEN rd.NumberOfTransmissions IS NOT NULL THEN CAST(rd.NumberOfTransmissions AS varchar(30))
		ELSE 'N/A'
	END AS NumberOfTransmissionsName
	,CASE
		WHEN  rd.LicenseEndDate = '9999-12-31 00:00:00.000' AND rd.LicenseStartDate = '1900-01-01 00:00:00.000' THEN 'Yes'
		ELSE 'No'
	END AS InPerpetuity
	,CASE 
		WHEN rd.LicenseStartDate = '1900-01-01' OR rd.LicenseEndDate = '9999-12-31' THEN
			0
		ELSE
			DATEDIFF ( DAY, rd.LicenseStartDate, rd.LicenseEndDate)
	END  AS LicenseDuration
FROM
	[$(MediaDMStaging)].dbo.OrderDetailRightsDetail rd
	LEFT JOIN [$(MediaDMStaging)].dbo.RightsSelectionEx rs ON rs.Id = rd.RightsSelectionId
	LEFT JOIN [$(MediaDMStaging)].dbo.TerritorySelectionEx ts ON ts.Id = rd.TerritorySelectionId
	LEFT JOIN [$(MediaDMStaging)].dbo.LanguageSelectionEx ls ON ls.Id = rd.LanguageSelectionId
UNION ALL
SELECT
	dbo.CreateKeyFromSourceID(-1) AS DealRightsKey
	,-1 AS SourceDealRightsId
	,'Unknown' AS DealRightsDescription
	,'N/A' AS Exclusive
	,'N/A' AS TerritoryDescription
	,'N/A' AS LanguageDescription
	,NULL AS LicenseStart
	,NULL AS LicenseEnd
	,0 AS NumberOfTransmissions
	,'N/A' AS NumberOfTransmissionsName
	,'No' AS InPerpetuity
	,0 AS LicenseDuration
) tt
;

MERGE 
    dbo.DimDealRights t
USING 
    #DimDealRights s ON (t.DealRightsKey = s.DealRightsKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.DealRightsKey = s.DealRightsKey
		,t.SourceDealRightsId = s.SourceDealRightsId
		,t.DealRightsDescription = s.DealRightsDescription
		,t.Exclusive = s.Exclusive
		,t.TerritoryDescription = s.TerritoryDescription
		,t.LanguageDescription = s.LanguageDescription
		,t.LicenseStart = s.LicenseStart
		,t.LicenseEnd = s.LicenseEnd
		,t.NumberOfTransmissions = s.NumberOfTransmissions
		,t.NumberOfTransmissionsName = s.NumberOfTransmissionsName
		,t.InPerpetuity = s.LicenseDuration
		,t.LicenseDuration = s.LicenseDuration
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (DealRightsKey, SourceDealRightsId, DealRightsDescription, Exclusive, TerritoryDescription, LanguageDescription, 
	LicenseStart, LicenseEnd, NumberOfTransmissions, NumberOfTransmissionsName, InPerpetuity, LicenseDuration, HashKey)
    VALUES (s.DealRightsKey, s.SourceDealRightsId, s.DealRightsDescription, s.Exclusive, s.TerritoryDescription, s.LanguageDescription, 
	s.LicenseStart, s.LicenseEnd, s.NumberOfTransmissions, s.NumberOfTransmissionsName, s.InPerpetuity, s.LicenseDuration, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimDealRights] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimDealRights] TO [DataServices]
    AS [dbo];
GO

