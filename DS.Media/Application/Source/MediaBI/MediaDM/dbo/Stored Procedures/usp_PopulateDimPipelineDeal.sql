CREATE PROCEDURE [dbo].[usp_PopulateDimPipelineDeal]

AS
	DECLARE @DeletedOn AS DATETIME = GETDATE();

	IF OBJECT_ID('tempdb..#DimPipelineDeal') IS NOT NULL DROP TABLE #DimPipelineDeal

	SELECT * INTO #DimPipelineDeal FROM dbo.DimPipelineDeal WHERE 1 = 2;

	INSERT INTO #DimPipelineDeal
			   ([PipelineDealKey],
				[PipelineDealId],
				[SalesProgress],
				[Reason],
				[PipelineDealStatus],
				[CreatedDate],
				[UpdatedDate],
				[PipelineTerritorySelection],
				[CreatedBy],
				[IsExclusive],
				[HashKey],
				[DeletedOn]
				)
	SELECT 
		PipelineDealKey,
		PipelineDealId,
		SalesProgress,
		Reason,
		PipelineDealStatus,
		CreatedDate,
		UpdatedDate,
		PipelineTerritorySelection,
		CreatedBy,
		IsExclusive,
	    dbo.ufn_GetHashDimPipelineDeal (PipelineDealKey, PipelineDealId, SalesProgress,	Reason,	PipelineDealStatus,	CreatedDate, UpdatedDate, PipelineTerritorySelection, 
										CreatedBy) AS HashKey,
		NULL AS DeletedOn
	FROM (
	SELECT 
		dbo.CreateKeyFromSourceID(p.[Id]) AS PipelineDealKey
		,p.[Id] AS [PipelineDealId]
		,p.[SalesProgress] / 100 AS [SalesProgress]
		,COALESCE(LEFT(p.[Info],4000), 'N/A') AS [Reason]
		,CASE 
			WHEN p.[StatusId] = 2 THEN 'Deleted' 
			ELSE 'Active'
		END AS [PipelineDealStatus]
		,CAST(p.[CreatedDate] AS DATE) AS [CreatedDate]
--		,COALESCE(CAST(p.[UpdatedDate] AS DATE), '1900-01-01') AS [UpdatedDate]
		,CAST(p.[UpdatedDate] AS DATE) AS [UpdatedDate]
		,ts.[Description] AS [PipelineTerritorySelection]
		,u.Firstname + ' ' + u.Lastname AS [CreatedBy]
		,CASE  
			WHEN p.Exclusive = 0 THEN 'No' 
			WHEN p.Exclusive = 1 THEN 'Yes' 
			ELSE 'N/A' 
		END AS [IsExclusive]
	FROM [$(MediaDMStaging)].[dbo].[PipelineDeal] p
	LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritorySelectionEx] ts ON p.[TerritorySelectionId] = ts.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] u ON p.CreatedBy = u.Id

	UNION ALL

	SELECT
		dbo.CreateKeyFromSourceID(-1) AS PipelineDealKey
		,-1 AS [PipelineDealId]
		,-1 AS [SalesProgress]
		,'N/A' AS [Reason]
		,'N/A' AS [PipelineDealStatus]
		,NULL AS [CreatedDate]
		,NULL AS [UpdatedDate]
		,'N/A' AS [PipelineTerritorySelection]
		,'N/A' AS [CreatedBy]
		,'N/A' AS [IsExclusive]
	) tt


MERGE 
    dbo.DimPipelineDeal t
USING 
    #DimPipelineDeal s ON (t.PipelineDealKey = s.PipelineDealKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.PipelineDealKey = s.PipelineDealKey,
		t.PipelineDealId = s.PipelineDealId,
		t.SalesProgress = s.SalesProgress,
		t.Reason = s.Reason,
		t.PipelineDealStatus = s.PipelineDealStatus,
		t.CreatedDate = s.CreatedDate,
		t.UpdatedDate = s.UpdatedDate,
		t.PipelineTerritorySelection = s.PipelineTerritorySelection,
		t.CreatedBy = s.CreatedBy,
		t.IsExclusive = s.IsExclusive,
		t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PipelineDealKey, PipelineDealId, SalesProgress,	Reason,	PipelineDealStatus,	CreatedDate, UpdatedDate, PipelineTerritorySelection, CreatedBy, IsExclusive, HashKey)
    VALUES (s.PipelineDealKey, s.PipelineDealId, s.SalesProgress, s.Reason,	s.PipelineDealStatus, s.CreatedDate, s.UpdatedDate, s.PipelineTerritorySelection, 
	        s.CreatedBy, s.IsExclusive, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0
;

GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimPipelineDeal] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimPipelineDeal] TO [DataServices]
    AS [dbo];
GO

