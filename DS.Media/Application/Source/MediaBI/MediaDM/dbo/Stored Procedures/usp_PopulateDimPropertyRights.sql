CREATE PROCEDURE [dbo].[usp_PopulateDimPropertyRights]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimPropertyRights') IS NOT NULL DROP TABLE #DimPropertyRights

SELECT * INTO #DimPropertyRights FROM dbo.DimPropertyRights WHERE 1 = 2;


INSERT INTO #DimPropertyRights (PropertyRightsKey, SourcePropertyRightsId
	,RightsSelection, TerritorySelection, LanguageSelection, LicenseStartDate, LicenseEndDate, InPerpetuity, HashKey, DeletedOn)
SELECT 
	 PropertyRightsKey
	,SourcePropertyRightsId
	,RightsSelection
	,TerritorySelection
	,LanguageSelection
	,LicenseStartDate
	,LicenseEndDate
	,InPerpetuity
    ,dbo.ufn_GetHashDimPropertyRights(PropertyRightsKey, SourcePropertyRightsId, RightsSelection, TerritorySelection, LanguageSelection, 
	                                  LicenseStartDate, LicenseEndDate, InPerpetuity) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(dr.Id) AS PropertyRightsKey
	,dr.Id AS SourcePropertyRightsId
	,ISNULL(rl.Description, 'Unknown') AS RightsSelection
	,ISNULL(tl.Description, 'Unknown') AS TerritorySelection
	,ISNULL(ll.Description, 'Unknown') AS LanguageSelection	
	,dr.LicenseStartDate
	,dr.LicenseEndDate
	,CASE
		WHEN  dr.LicenseEndDate = '9999-12-31 00:00:00.000' AND dr.LicenseStartDate = '1900-01-01 00:00:00.000' THEN 'Yes'
		ELSE 'No'
	END AS InPerpetuity
FROM
	[$(MediaDMStaging)].dbo.DesignatedRight dr
	LEFT JOIN [$(MediaDMStaging)].dbo.RightsSelectionEx rl ON dr.RightsSelectionId = rl.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.TerritorySelectionEx tl ON dr.TerritorySelectionId = tl.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.LanguageSelectionEx ll ON dr.LanguageSelectionId = ll.Id
UNION ALL
SELECT
	dbo.CreateKeyFromSourceID(-1) AS PropertyRightsKey
	,-1 AS SourcePropertyRightsId
	,'Unknown' AS RightsSelection
	,'Unknown' AS TerritorySelection
	,'Unknown' AS LanguageSelection
--	,'1900-01-01' AS LicenseStartDate
--	,'9999-12-31' AS LicenseEndDate
	,NULL AS LicenseStartDate
	,NULL AS LicenseEndDate
	,'No' AS InPerpetuity
) tt;


MERGE 
    dbo.DimPropertyRights t
USING 
    #DimPropertyRights s ON (t.PropertyRightsKey = s.PropertyRightsKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.PropertyRightsKey = s.PropertyRightsKey
		,t.SourcePropertyRightsId = s.SourcePropertyRightsId
		,t.RightsSelection = s.RightsSelection
		,t.TerritorySelection = s.TerritorySelection
		,t.LanguageSelection = s.LanguageSelection
		,t.LicenseStartDate = s.LicenseStartDate
		,t.LicenseEndDate = s.LicenseEndDate
		,t.InPerpetuity = s.InPerpetuity
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PropertyRightsKey, SourcePropertyRightsId, RightsSelection, TerritorySelection, LanguageSelection, 
	                                  LicenseStartDate, LicenseEndDate, InPerpetuity, HashKey)
    VALUES (s.PropertyRightsKey, s.SourcePropertyRightsId, s.RightsSelection, s.TerritorySelection, s.LanguageSelection, 
	                                  s.LicenseStartDate, s.LicenseEndDate, s.InPerpetuity, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimPropertyRights] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimPropertyRights] TO [DataServices]
    AS [dbo];
GO
