CREATE PROCEDURE [dbo].[usp_PopulateDimPropertyVersion]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimPropertyVersion') IS NOT NULL DROP TABLE #DimPropertyVersion

SELECT * INTO #DimPropertyVersion FROM dbo.DimPropertyVersion WHERE 1 = 2;


INSERT INTO #DimPropertyVersion (VersionKey, PropertyKey,
	BroadcastType, VersionName, AvailabilityDate, HashKey, DeletedOn)
SELECT 
	 VersionKey
	,PropertyKey
	,BroadcastType
	,VersionName
	,AvailabilityDate
    ,dbo.ufn_GetHashDimPropertyVersion(PropertyKey, BroadcastType, VersionName, AvailabilityDate) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	 COALESCE(dbo.CreateKeyFromSourceID(v.Id),dbo.CreateKeyFromSourceID(-1)) AS VersionKey
	,dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey
	,COALESCE(pt.[Description],'N/A') AS BroadcastType
	,COALESCE(v.[Description],'N/A') AS VersionName
--	,COALESCE(v.AvailableDate,'1900-01-01') AS AvailabilityDate
    ,v.AvailableDate AS AvailabilityDate
FROM
	[$(MediaDMStaging)].dbo.Product p
	LEFT JOIN [$(MediaDMStaging)].dbo.[Version] v ON p.Id = v.ProductId
	LEFT JOIN [$(MediaDMStaging)].dbo.ProductType_lu pt on pt.Id = v.VersionType
UNION ALL
SELECT
	dbo.CreateKeyFromSourceID(-1) AS VersionKey
	,dbo.CreateKeyFromSourceID(-1) AS PropertyKey
	,'N/A' AS BroadcastType
	,'N/A' AS VersionName
	,NULL AS AvailabilityDate
) tt;
CREATE CLUSTERED INDEX CI_Version on #DimPropertyVersion (VersionKey,PropertyKey)

MERGE 
    dbo.DimPropertyVersion t
USING 
    #DimPropertyVersion s ON (t.VersionKey = s.VersionKey AND t.PropertyKey = s.PropertyKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.PropertyKey = s.PropertyKey
	    ,t.BroadcastType = s.BroadcastType
		,t.VersionName = s.VersionName
		,t.AvailabilityDate = s.AvailabilityDate
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (VersionKey, PropertyKey, BroadcastType, VersionName, AvailabilityDate, HashKey)
    VALUES (s.VersionKey, s.PropertyKey, s.BroadcastType, s.VersionName, s.AvailabilityDate, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO


GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimPropertyVersion] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimPropertyVersion] TO [DataServices]
    AS [dbo];
GO