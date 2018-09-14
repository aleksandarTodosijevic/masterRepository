CREATE PROCEDURE [dbo].[usp_PopulateFactRights]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactRights') IS NOT NULL DROP TABLE #FactRights

SELECT * INTO #FactRights FROM dbo.FactRights WHERE 1 = 2;

------------ Entertainment Shipped Dates-----------------
DROP TABLE IF EXISTS #tempShippedDates

;WITH CTE_ProductSeries 
AS
(
	SELECT p.Id AS ParentId, p.Id, 0 AS Level
	FROM [$(MediaDMStaging)].[dbo].[Product] p
	WHERE p.ParentId IS NULL
	UNION ALL
	SELECT p.ParentId, p.Id, Level +1
	FROM [$(MediaDMStaging)].[dbo].[Product] p
	INNER JOIN CTE_ProductSeries ps ON p.ParentId = ps.Id
)
SELECT *
INTO #tempShippedDates
FROM (
	SELECT 
		odd.OrderHeaderId AS DealId
		,p.Id AS ProductId
		,p.ParentId
		,p.[Level]
		,MIN(odd.ShippedDate) OVER (PARTITION BY odd.OrderHeaderId, p.Id) AS MinShippedDate
		,ROW_NUMBER() OVER (PARTITION BY odd.OrderHeaderId, p.Id ORDER BY p.Id) AS NumberOfRow
	FROM [$(MediaDMStaging)].[dbo].[OrderDetailDelivery] odd 
	INNER JOIN CTE_ProductSeries p ON odd.ProductId = p.Id
	WHERE odd.StatusId = 1  AND p.[Level] = 1
	UNION ALL
		SELECT 
		odd.OrderHeaderId AS DealId
		,h.Id AS ProductId
		,p.ParentId
		,h.[Level]
		,MIN(odd.ShippedDate) OVER (PARTITION BY odd.OrderHeaderId, h.id) AS MinShippedDate
		,ROW_NUMBER() OVER (PARTITION BY odd.OrderHeaderId, h.id ORDER BY h.id) AS NumberOfRow
	FROM [$(MediaDMStaging)].[dbo].[OrderDetailDelivery] odd 
	INNER JOIN CTE_ProductSeries p ON odd.ProductId = p.Id
	INNER JOIN CTE_ProductSeries h ON h.Id = p.ParentId
	WHERE odd.StatusId = 1  AND h.[Level] = 0
) AS t
WHERE 0=0
AND  t.NumberOfRow = 1
CREATE CLUSTERED INDEX CI_ShippedDates ON #tempShippedDates (DealId, ProductId)


INSERT INTO #FactRights 
   (CustomerContactKey, DealKey, LicenseStartDateKey, LicenseEndDateKey, 
	PropertyKey, ProjectionKey, DealPropertyKey, DealRightsKey, PropertyRightsKey, DealCreatedByKey, DealCreatedOnDateKey, 
	DealUpdatedByKey, DealUpdatedOnDateKey,EntertainmentShippedDateKey, RecognitionDateKey, HashKey, DeletedOn)
SELECT 
	 CustomerContactKey
	,DealKey
	,LicenseStartDateKey
	,LicenseEndDateKey
	,PropertyKey
	,ProjectionKey
	,DealPropertyKey
	,DealRightsKey
	,PropertyRightsKey
	,DealCreatedByKey
	,DealCreatedOnDateKey
	,DealUpdatedByKey
	,DealUpdatedOnDateKey
	,EntertainmentShippedDateKey
	,RecognitionDateKey
	,dbo.ufn_GetHashFactRights (LicenseStartDateKey, LicenseEndDateKey, PropertyKey, ProjectionKey, DealPropertyKey, DealRightsKey, PropertyRightsKey,EntertainmentShippedDateKey, RecognitionDateKey) AS HashKey
    ,NULL AS DeletedOn
FROM (

SELECT
	 dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), ISNULL(sold.CustomerId, -1))
		+':'+CONVERT(VARCHAR(10), ISNULL(sold.CustomerContactId, -1))
		+ ':' + CAST(ISNULL(sold.CustomerAddressId,-1) AS VARCHAR(10))
	 ) as CustomerContactKey
	,dbo.CreateKeyFromSourceID(ISNULL(sold.OrderHeaderId, -1)) AS DealKey
	,dbo.CreateKeyFromDate(ISNULL(sold.LicenseStartDate, '1900-01-01')) AS LicenseStartDateKey
	,dbo.CreateKeyFromDate(ISNULL(sold.LicenseEndDate, '9999-12-31')) AS LicenseEndDateKey
	,dbo.CreateKeyFromSourceID(p.ProductId) AS PropertyKey
	,dbo.CreateKeyFromSourceID(COALESCE(pr.ProjectionNo, '-1') + ':' + COALESCE(pr.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
	,dbo.CreateKeyFromSourceID(COALESCE(sold.OrderDetailId, -1)) as DealPropertyKey
	,dbo.CreateKeyFromSourceID(ISNULL(sold.Id, -1)) AS DealRightsKey
	,dbo.CreateKeyFromSourceID(p.Id) AS PropertyRightsKey
	,dbo.CreateKeyFromSourceID(COALESCE(sold.CreatedBy,-1)) AS DealCreatedByKey
	,dbo.CreateKeyFromDate(COALESCE(sold.CreatedDate, '1900-01-01')) AS DealCreatedOnDateKey
	,dbo.CreateKeyFromSourceID(COALESCE(sold.UpdatedBy, sold.CreatedBy, -1)) AS DealUpdatedByKey
	,dbo.CreateKeyFromDate(COALESCE(sold.UpdatedDate, sold.CreatedDate, '1900-01-01')) AS DealUpdatedOnDateKey
	,dbo.CreateKeyFromDate(ISNULL(tsd.MinShippedDate,'1900-01-01')) AS EntertainmentShippedDateKey
	,dbo.CreateKeyFromDate(ISNULL(
		(SELECT MAX(x) FROM (VALUES (sold.LicenseStartDate),(tsd.MinShippedDate)) AS value(x))
	,'1900-01-01')) AS RecognitionDateKey
FROM
	[$(MediaDMStaging)].dbo.DesignatedRight p WITH (NOLOCK)
	LEFT JOIN [$(MediaDMStaging)].dbo.Product pr WITH (NOLOCK) ON p.ProductId = pr.Id
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc WITH (NOLOCK) ON sc.Id = pr.SubjectCategoryId
	LEFT JOIN 
	(
		SELECT 
			rd.DesignatedRightId, rd.LanguageSelectionId, rd.Id, rd.RightsSelectionId, od.Id AS OrderDetailId
			,rd.Exclusive ,rd.LicenseStartDate ,rd.LicenseEndDate ,od.OrderHeaderId ,oh.CustomerId ,oh.CreatedBy 
			,oh.CreatedDate, oh.UpdatedBy, oh.UpdatedDate, oh.SalesAreaId, cc.Id AS CustomerContactId
			,oi.CustomerAddressId
		FROM [$(MediaDMStaging)].dbo.OrderDetailRightsDetail rd WITH (NOLOCK)
		INNER JOIN [$(MediaDMStaging)].dbo.OrderDetail od WITH (NOLOCK)
			ON od.Id = rd.OrderDetailId
		INNER JOIN [$(MediaDMStaging)].dbo.OrderHeader oh WITH (NOLOCK)
			ON oh.Id = od.OrderHeaderId
		LEFT JOIN [$(MediaDMStaging)].[dbo].[Contract] oi WITH (NOLOCK) ON od.ContractId = oi.Id
		LEFT JOIN [$(MediaDMStaging)].[dbo].[CustomerContact] cc WITH (NOLOCK) ON cc.CustomerId = oh.CustomerId AND cc.Id = oi.CustomerContactid
		WHERE
			rd.StatusId = 1
			AND od.StatusId = 1
			AND oh.StatusId = 1 AND oh.OrderStatusId <> 1
	) as sold ON sold.DesignatedRightId = p.Id
	LEFT JOIN #tempShippedDates tsd ON sold.OrderHeaderId = tsd.DealId AND p.ProductId = tsd.ProductId
WHERE p.StatusId = 1 or sold.DesignatedRightId is not null
) tt;



MERGE 
    dbo.FactRights AS t
USING 
    #FactRights AS s ON (
				t.CustomerContactKey = s.CustomerContactKey
			AND t.DealKey = s.DealKey
			AND t.PropertyKey = s.PropertyKey
		    AND t.ProjectionKey = s.ProjectionKey
			AND t.DealPropertyKey = s.DealPropertyKey
			AND t.DealRightsKey = s.DealRightsKey
			AND t.PropertyRightsKey = s.PropertyRightsKey
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
			t.CustomerContactKey = s.CustomerContactKey
		   ,t.DealKey = s.DealKey
		   ,t.LicenseStartDateKey = s.LicenseStartDateKey
		   ,t.LicenseEndDateKey = s.LicenseEndDateKey
		   ,t.PropertyKey = s.PropertyKey
		   ,t.ProjectionKey = s.ProjectionKey
		   ,t.DealPropertyKey = s.DealPropertyKey
		   ,t.DealRightsKey = s.DealRightsKey
		   ,t.PropertyRightsKey = s.PropertyRightsKey
		   ,t.DealCreatedByKey = s.DealCreatedByKey
		   ,t.DealCreatedOnDateKey = s.DealCreatedOnDateKey
		   ,t.DealUpdatedByKey = s.DealUpdatedByKey
		   ,t.DealUpdatedOnDateKey = s.DealUpdatedOnDateKey
		   ,t.EntertainmentShippedDateKey = s.EntertainmentShippedDateKey
		   ,t.RecognitionDateKey = s.EntertainmentShippedDateKey
		   ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CustomerContactKey, DealKey, LicenseStartDateKey, LicenseEndDateKey, PropertyKey, ProjectionKey, DealPropertyKey, DealRightsKey, 
	PropertyRightsKey, DealCreatedByKey, DealCreatedOnDateKey, DealUpdatedByKey, DealUpdatedOnDateKey, EntertainmentShippedDateKey, RecognitionDateKey, HashKey)
    VALUES (s.CustomerContactKey, s.DealKey, s.LicenseStartDateKey, s.LicenseEndDateKey, s.PropertyKey, s.ProjectionKey, s.DealPropertyKey, s.DealRightsKey, 
	s.PropertyRightsKey, s.DealCreatedByKey, s.DealCreatedOnDateKey, s.DealUpdatedByKey, s.DealUpdatedOnDateKey, s.EntertainmentShippedDateKey, s.RecognitionDateKey, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateFactRights] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactRights] TO [DataServices]
    AS [dbo];
GO
