CREATE PROCEDURE [dbo].[usp_PopulateFactClientRepresentations]

AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactClientRepresentations') IS NOT NULL DROP TABLE #FactClientRepresentations

SELECT * INTO #FactClientRepresentations FROM dbo.FactClientRepresentations WHERE 1 = 2;



INSERT INTO #FactClientRepresentations 
   (PropertyKey, ClientKey, UltimateOwnerKey, IsUltimateOwner, HashKey, DeletedOn)
SELECT 
	 PropertyKey
	,ClientKey
	,UltimateOwnerKey
	,IsUltimateOwner
	,dbo.ufn_GetHashFactClientRepresentations (UltimateOwnerKey, IsUltimateOwner) AS HashKey
    ,NULL AS DeletedOn
FROM (
	SELECT
		DISTINCT dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey,
		dbo.CreateKeyFromSourceID(cra.ClientId) AS ClientKey
		,dbo.CreateKeyFromSourceID(COALESCE(uo.UltimateOwnerId, -1)) AS UltimateOwnerKey
		,CASE WHEN uo.UltimateOwnerId IS NOT NULL THEN 1 ELSE 0 END AS IsUltimateOwner
	FROM [$(MediaDMStaging)].[dbo].ProductRepresentationAgreement pra 
	INNER JOIN [$(MediaDMStaging)].[dbo].RepresentationAgreement ra ON pra.RepresentationAgreementId = ra.Id
	INNER JOIN [$(MediaDMStaging)].[dbo].ClientRepresentationAgreement cra ON cra.RepresentationAgreementId = ra.Id 
	INNER JOIN [$(MediaDMStaging)].[dbo].Product p ON pra.ProductId = p.Id
	LEFT JOIN 
	(
		SELECT pr.Id, pr.UltimateOwnerId
		FROM [$(MediaDMStaging)].[dbo].Product pr
		WHERE pr.UltimateOwnerId IS NOT NULL
			AND pr.StatusId = 1
	) AS uo ON p.Id = uo.Id
	WHERE   
		(cra.StatusId = 1) 
		AND (ra.StatusId = 1) 
		AND (pra.StatusId = 1)
) tt;


MERGE 
    dbo.FactClientRepresentations AS t
USING 
    #FactClientRepresentations AS s ON (
				t.PropertyKey = s.PropertyKey
	        AND t.ClientKey = s.ClientKey
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		    t.UltimateOwnerKey = s.UltimateOwnerKey
		   ,t.IsUltimateOwner = s.IsUltimateOwner
		   ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PropertyKey, ClientKey, UltimateOwnerKey, IsUltimateOwner, HashKey)
    VALUES (s.PropertyKey, s.ClientKey, s.UltimateOwnerKey, s.IsUltimateOwner, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0; 

GO

GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactClientRepresentations] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactClientRepresentations] TO [DataServices]
    AS [dbo];
GO

