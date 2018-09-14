creAte PROCEDURE [dbo].[usp_PopulateFactDeliveries]
AS

SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactDeliveries') IS NOT NULL DROP TABLE #FactDeliveries

SELECT * INTO #FactDeliveries FROM dbo.FactDeliveries WHERE 1 = 2;


INSERT INTO #FactDeliveries 
   (DeliveryKey, PropertyKey, ProjectionKey, DealKey, HashKey, DeletedOn)
SELECT 
	 DeliveryKey
	,PropertyKey
	,ProjectionKey
	,DealKey
	--,dbo.ufn_GetHashFactDeliveries(...) AS HashKey
	,NULL AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(odd.Id) AS DeliveryKey,
	dbo.CreateKeyFromSourceID(odd.ProductId) AS PropertyKey,
	dbo.CreateKeyFromSourceID(pr.ProjectionNo + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10)), '-1')) ProjectionKey,
	dbo.CreateKeyFromSourceID(odd.OrderHeaderId) as DealKey
FROM [$(MediaDMStaging)].[dbo].OrderDetailDelivery odd
	INNER JOIN [$(MediaDMStaging)].[dbo].Product pr ON pr.Id = odd.ProductId
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = pr.SubjectCategoryId
WHERE odd.StatusId = 1
) tt;

MERGE 
    dbo.FactDeliveries AS t
USING 
    #FactDeliveries AS s ON (
				t.DeliveryKey = s.DeliveryKey
			AND t.PropertyKey = s.PropertyKey
			AND	t.ProjectionKey = s.ProjectionKey
			AND	t.DealKey = s.DealKey
					 )
WHEN NOT MATCHED BY TARGET THEN
    INSERT (DeliveryKey, PropertyKey, ProjectionKey, DealKey, HashKey)
    VALUES (s.DeliveryKey, s.PropertyKey, s.ProjectionKey, s.DealKey, NULL)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;

GO

GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactDeliveries] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactDeliveries] TO [DataServices]
    AS [dbo];
GO

