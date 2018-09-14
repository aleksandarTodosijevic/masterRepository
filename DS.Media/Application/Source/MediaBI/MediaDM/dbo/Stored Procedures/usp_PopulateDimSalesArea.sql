CREATE PROCEDURE [dbo].[usp_PopulateDimSalesArea]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimSalesArea') IS NOT NULL DROP TABLE #DimSalesArea

SELECT * INTO #DimSalesArea FROM dbo.DimSalesArea WHERE 1 = 2;


INSERT INTO #DimSalesArea 
   (SalesAreaKey, SourceSalesAreaId, SalesRegion, SalesArea, AreaNumber, ExecResponsible, SalesAreaStatus, EntertainmentSalesExec, HashKey, DeletedOn)
SELECT 
	 SalesAreaKey
	,SourceSalesAreaId
	,SalesRegion
	,SalesArea
	,AreaNumber
	,ExecResponsible
	,SalesAreaStatus
	,EntertainmentSalesExec
    ,dbo.ufn_GetHashDimSalesArea(SalesAreaKey, SourceSalesAreaId, SalesRegion, SalesArea, AreaNumber, ExecResponsible, SalesAreaStatus, EntertainmentSalesExec) AS HashKey
    ,NULL AS DeletedOn
FROM (

	SELECT dbo.CreateKeyFromSourceID(a.Id) AS SalesAreaKey
		,a.Id AS SourceSalesAreaId
		,r.Description AS SalesRegion
		,a.Description AS SalesArea
		,a.AreaNumber
		,u.Firstname+' '+u.Lastname AS ExecResponsible
		,s.[Description] AS SalesAreaStatus
		,COALESCE(mds.[EntertainmentSalesExec], 'N/A') AS [EntertainmentSalesExec]
	FROM [$(MediaDMStaging)].dbo.SalesArea a
	JOIN [$(MediaDMStaging)].dbo.SalesRegion_lu r ON r.Id = a.SalesRegionId
	LEFT JOIN [$(MediaDMStaging)].dbo.[User] u ON u.Id = a.ExecResponsibleId
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Status] s ON a.StatusId = s.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[MDS_SalesArea] mds ON a.Id =mds.[Code]

	UNION ALL

	SELECT dbo.CreateKeyFromSourceID(-1) AS SalesAreaKey
		,-1 AS SourceSalesAreaId
		,'N/A' AS SalesRegion
		,'N/A' AS SalesArea
		,-1 AS AreaNumber
		,'N/A' AS ExecResponsible
		,'N/A' AS SalesAreaStatus
		,'N/A' AS [EntertainmentSalesExec]

) tt;

MERGE 
    dbo.DimSalesArea t
USING 
    #DimSalesArea s ON (t.SalesAreaKey = s.SalesAreaKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.SalesAreaKey = s.SalesAreaKey
		,t.SourceSalesAreaId = s.SourceSalesAreaId
		,t.SalesRegion = s.SalesRegion
		,t.SalesArea = s.SalesArea
		,t.AreaNumber = s.AreaNumber
		,t.ExecResponsible = s.ExecResponsible
		,t.SalesAreaStatus = s.SalesAreaStatus
		,t.EntertainmentSalesExec = s.EntertainmentSalesExec
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (SalesAreaKey, SourceSalesAreaId, SalesRegion, SalesArea, AreaNumber, ExecResponsible, SalesAreaStatus, EntertainmentSalesExec, HashKey)
    VALUES (s.SalesAreaKey, s.SourceSalesAreaId, s.SalesRegion, s.SalesArea, s.AreaNumber, s.ExecResponsible, s.SalesAreaStatus, EntertainmentSalesExec, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimSalesArea] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimSalesArea] TO [DataServices]
    AS [dbo];
GO
