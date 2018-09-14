CREATE PROCEDURE [dbo].[usp_PopulateDimClient]

AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimClient') IS NOT NULL DROP TABLE #DimClient
	
	-- Client address logic from [dbo].[fn_GetBeneficialOwnerDetailsForSAP]
IF OBJECT_ID('tempdb..#ClientAddress') IS NOT NULL DROP TABLE #ClientAddress

SELECT * INTO #DimClient FROM dbo.DimClient WHERE 1 = 2;

SELECT 
	Adr.ClientId, 
	Adr.Line1 +  ' ' + 
	CASE ISNULL(Adr.Line2,'') WHEN '' THEN '' ELSE Adr.Line2 + ', ' END + 
	CASE ISNULL(Adr.Line3,'') WHEN '' THEN '' ELSE Adr.Line3 + ', ' END + 
	CASE ISNULL(Adr.Line6,'') WHEN '' THEN '' ELSE Adr.Line6 + ', ' END +
	CASE ISNULL(TR.Description,'') WHEN '' THEN '' ELSE TR.Description + ' ' END + 
	CASE ISNULL(TE.Description,'') WHEN '' THEN '' ELSE TE.Description + ' ' END AS ClientAddress
	,TE.[Description] AS ClientCountry
	,ROW_NUMBER() OVER (PARTITION BY Adr.ClientId ORDER BY Adr.Id) AS RowNumber
	INTO #ClientAddress 
FROM 	
	[$(MediaDMStaging)].[dbo].ClientAddress Adr WITH (NOLOCK)
	INNER JOIN [$(MediaDMStaging)].[dbo].Territory_lu TE WITH (NOLOCK) ON Adr.TerritoryId = TE.Id
	LEFT OUTER JOIN [$(MediaDMStaging)].[dbo].TerritoryRegion_lu TR WITH (NOLOCK) ON Adr.TerritoryRegionId = TR.Id
WHERE 
	Adr.StatusId = 1
	AND CategoryBitSum & 32 > 0

CREATE CLUSTERED INDEX IC_ClientAddress ON #ClientAddress (ClientId)

INSERT INTO #DimClient

SELECT 
	ClientKey
	,ClientNo
	,ClientNoInt
	,ClientName
	,ClientName2
	,ClientFullName
	,ClientAddress
	,ClientCountry
	,IsIMGClient
	,IsProjectionClient
	,IsUltimateOwner
    ,dbo.ufn_GetHashDimClient(ClientKey, ClientNo, ClientNoInt, ClientName, ClientName2, ClientFullName, ClientAddress, ClientCountry, IsIMGClient, IsProjectionClient, IsUltimateOwner) AS HashKey
    ,NULL AS DeletedOn
FROM (

SELECT 
	dbo.CreateKeyFromSourceID(c.Id) AS ClientKey,
	COALESCE(CAST(c.ClientNo AS VARCHAR(10)),'N/A') AS ClientNo,
	COALESCE(c.ClientNo, -1) AS ClientNoInt,
	COALESCE(c.ClientName,'N/A') AS ClientName,
	COALESCE(c.ClientName2,'N/A') AS ClientName2,
	COALESCE(c.ClientFullName,'N/A') AS ClientFullName,
	COALESCE(ca.ClientAddress,'N/A') AS ClientAddress,
	COALESCE(ca.ClientCountry, 'N/A') AS ClientCountry,
	CASE WHEN c.IsIMGClient = 1 THEN 'Yes' ELSE 'No' END AS IsIMGClient,
	CASE WHEN c.IsProjectionClient = 1 THEN 'Yes' ELSE 'No' END AS IsProjectionClient,
	CASE WHEN pr.UltimateOwnerId IS NULL THEN 'No' ELSE 'Yes' END AS IsUltimateOwner
FROM [$(MediaDMStaging)].[dbo].[Client] c 
LEFT JOIN #ClientAddress ca ON c.Id = ca.ClientId
LEFT JOIN (Select DISTINCT UltimateOwnerId FROM [$(MediaDMStaging)].[dbo].Product) pr ON c.Id = pr.UltimateOwnerId
WHERE   
	(c.StatusId = 1) 
UNION ALL
SELECT 
	dbo.CreateKeyFromSourceID(-1) AS ClientKey,
	'N/A' AS ClientNo,
	-1 AS ClientNoInt,
	'N/A' AS ClientName,
	'N/A' AS ClientName2,
	'N/A' AS ClientFullName,
	'N/A' AS ClientAddress,
	'N/A' AS ClientCountry,
	'N/A' AS IsIMGClient,
	'N/A' AS IsProjectionClient,
	'N/A' AS IsUltimateOwner
) tt


MERGE 
    dbo.DimClient t
USING 
    #DimClient s ON (t.ClientKey = s.ClientKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.ClientKey = s.ClientKey,
		t.ClientNo = s.ClientNo,
		t.ClientNoInt = s.ClientNoInt,
		t.ClientName = s.ClientName,
		t.ClientName2 = s.ClientName2,
		t.ClientFullName = s.ClientFullName,
		t.ClientAddress = s.ClientAddress,
		t.ClientCountry = s.ClientCountry,
		t.IsIMGClient = s.IsIMGClient,
		t.IsProjectionClient = s.IsProjectionClient,
		t.IsUltimateOwner = s.IsUltimateOwner, 
		t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ClientKey, ClientNo, ClientNoInt, ClientName, ClientName2, ClientFullName, ClientAddress, ClientCountry, IsIMGClient, IsProjectionClient, IsUltimateOwner, HashKey)
    VALUES (s.ClientKey, s.ClientNo, s.ClientNoInt, s.ClientName, s.ClientName2, s.ClientFullName, s.ClientAddress, s.ClientCountry, s.IsIMGClient, s.IsProjectionClient, s.IsUltimateOwner, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimClient] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimClient] TO [DataServices]
    AS [dbo];
GO
