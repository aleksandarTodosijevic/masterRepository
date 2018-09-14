CREATE PROCEDURE [dbo].[usp_PopulateDimPipelineDealHistory]

AS
	DECLARE @DeletedOn AS DATETIME = GETDATE();

	IF OBJECT_ID('tempdb..#DimPipelineDealHistory') IS NOT NULL DROP TABLE #DimPipelineDealHistory

	SELECT * INTO #DimPipelineDealHistory FROM dbo.DimPipelineDealHistory WHERE 1 = 2;

	INSERT INTO #DimPipelineDealHistory
			   ([PipelineDealHistoryKey],
				[PipelineDealId],
				[SalesProgress],
				[Reason],
				[PipelineDealStatus],
				[CreatedDate],
				[UpdatedDate],
				[PipelineTerritorySelection],
				[DescendingOrderOfChanges],
				[CreatedBy],
				[IsExclusive],
				[SalesProgressChange],
		        [ReasonChange],
				[PipelineDealStatusChange],
				[PipelineTerritorySelectionChange],
				[IsExclusiveChange],
				[HashKey],
				[DeletedOn])
	SELECT 
		PipelineDealHistoryKey,
		PipelineDealId,
		SalesProgress,
		Reason,
		PipelineDealStatus,
		CreatedDate,
		UpdatedDate,
		PipelineTerritorySelection,
		[DescendingOrderOfChanges] AS DescendingOrderOfChanges,
		CreatedBy,
		IsExclusive,
		SalesProgressChange,
		ReasonChange,
		PipelineDealStatusChange,
		PipelineTerritorySelectionChange,
		IsExclusiveChange,
	    dbo.ufn_GetHashDimPipelineDealHistory (PipelineDealHistoryKey, PipelineDealId, SalesProgress, Reason, PipelineDealStatus, CreatedDate, UpdatedDate, PipelineTerritorySelection, 
										[DescendingOrderOfChanges], CreatedBy, SalesProgressChange, ReasonChange, PipelineDealStatusChange, PipelineTerritorySelectionChange, IsExclusiveChange) AS HashKey,
		NULL AS DeletedOn
	FROM (

	SELECT 
	    PipelineDealHistoryKey,
		PipelineDealId,
		SalesProgress,
		Reason,
		PipelineDealStatus,
		CreatedDate,
		UpdatedDate,
		PipelineTerritorySelection,
		[DescendingOrderOfChanges] AS DescendingOrderOfChanges,
		CreatedBy,
		IsExclusive,
		CASE WHEN LEAD(tmt.SalesProgress) OVER (PARTITION BY tmt.PipelineDealId ORDER BY tmt.DescendingOrderOfChanges) = tmt.SalesProgress THEN 'No' ELSE 'Yes' END SalesProgressChange,
		CASE WHEN LEAD(tmt.Reason) OVER (PARTITION BY tmt.PipelineDealId ORDER BY tmt.DescendingOrderOfChanges) = tmt.Reason THEN 'No' ELSE 'Yes' END ReasonChange,
		CASE WHEN LEAD(tmt.PipelineDealStatus) OVER (PARTITION BY tmt.PipelineDealId ORDER BY tmt.DescendingOrderOfChanges) = tmt.PipelineDealStatus THEN 'No' ELSE 'Yes' END PipelineDealStatusChange,
		CASE WHEN LEAD(tmt.PipelineTerritorySelection) OVER (PARTITION BY tmt.PipelineDealId ORDER BY tmt.DescendingOrderOfChanges) = tmt.PipelineTerritorySelection THEN 'No' ELSE 'Yes' END PipelineTerritorySelectionChange,
		CASE WHEN LEAD(tmt.IsExclusive) OVER (PARTITION BY tmt.PipelineDealId ORDER BY tmt.DescendingOrderOfChanges) = tmt.IsExclusive THEN 'No' ELSE 'Yes' END IsExclusiveChange
    FROM (

	SELECT 
		dbo.CreateKeyFromSourceID(p.[Id]) AS PipelineDealHistoryKey
		,p.[PipelineDealId] AS [PipelineDealId]
		,(p.[SalesProgress]/100) AS [SalesProgress]
		,COALESCE(LEFT(p.[Info],4000), 'N/A') AS [Reason]
		,CASE 
			WHEN p.[StatusId] = 2 THEN 'Deleted' 
			ELSE 'Active'
		END AS [PipelineDealStatus]
		,CAST(p.[CreatedDate] AS DATE) AS [CreatedDate]
--		,COALESCE(CAST(p.[UpdatedDate] AS DATE), '1900-01-01') AS [UpdatedDate]
		,CAST(p.[UpdatedDate] AS DATE) AS [UpdatedDate]
		,ts.[Description] AS [PipelineTerritorySelection]
		,ROW_NUMBER() OVER (PARTITION BY p.PipelineDealId ORDER BY p.[Id] DESC) [DescendingOrderOfChanges]
		,u.Firstname + ' ' + u.Lastname AS [CreatedBy]
		,CASE  
			WHEN p.Exclusive = 0 THEN 'No' 
			WHEN p.Exclusive = 1 THEN 'Yes' 
			ELSE 'N/A' 
		END AS [IsExclusive]
	FROM [$(MediaDMStaging)].[dbo].[PipelineDealHistory] p
	LEFT JOIN [$(MediaDMStaging)].[dbo].[TerritorySelectionEx] ts ON p.[TerritorySelectionId] = ts.[Id]
	LEFT JOIN [$(MediaDMStaging)].[dbo].[User] u ON p.CreatedBy = u.Id
		) AS tmt

	UNION ALL

	SELECT
		dbo.CreateKeyFromSourceID(-1) AS PipelineDealHistoryKey
		,-1 AS [PipelineDealId]
		,-1 AS [SalesProgress]
		,'N/A' AS [Reason]
		,'N/A' AS [PipelineDealStatus]
		,NULL AS [CreatedDate]
		,NULL AS [UpdatedDate]
		,'N/A' AS [PipelineTerritorySelection]
		,-1 AS [Descending order of changes]
		,'N/A' AS [CreatedBy]
		,'N/A' AS [IsExclusive]
        ,'N/A' AS [SalesProgressChange]
        ,'N/A' AS [ReasonChange]
        ,'N/A' AS [PipelineDealStatusChange]
		,'N/A' AS [PipelineTerritorySelectionChange]
		,'N/A' AS [IsExclusiveChange]
	) tt

	;


MERGE 
    dbo.DimPipelineDealHistory t
USING 
    #DimPipelineDealHistory s ON (t.PipelineDealHistoryKey = s.PipelineDealHistoryKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		t.PipelineDealHistoryKey = s.PipelineDealHistoryKey,
		t.PipelineDealId = s.PipelineDealId,
		t.SalesProgress = s.SalesProgress,
		t.Reason = s.Reason,
		t.PipelineDealStatus = s.PipelineDealStatus,
		t.CreatedDate = s.CreatedDate,
		t.UpdatedDate = s.UpdatedDate,
		t.PipelineTerritorySelection = s.PipelineTerritorySelection,
		t.DescendingOrderOfChanges = s.DescendingOrderOfChanges,
		t.CreatedBy = s.CreatedBy,
		t.IsExclusive = s.IsExclusive,
		t.SalesProgressChange = s.SalesProgressChange,
		t.ReasonChange = s.ReasonChange,
		t.PipelineDealStatusChange = s.PipelineDealStatusChange,
		t.PipelineTerritorySelectionChange = s.PipelineTerritorySelectionChange,
		t.IsExclusiveChange = s.IsExclusiveChange,
		t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PipelineDealHistoryKey, PipelineDealId, SalesProgress,	Reason,	PipelineDealStatus,	CreatedDate, UpdatedDate, PipelineTerritorySelection, DescendingOrderOfChanges, 
			CreatedBy, IsExclusive, SalesProgressChange, ReasonChange, PipelineDealStatusChange, PipelineTerritorySelectionChange, IsExclusiveChange, HashKey)
    VALUES (s.PipelineDealHistoryKey, s.PipelineDealId, s.SalesProgress, s.Reason,	s.PipelineDealStatus, s.CreatedDate, s.UpdatedDate, s.PipelineTerritorySelection, 
	        s.DescendingOrderOfChanges, s.CreatedBy, s.IsExclusive, s.SalesProgressChange, s.ReasonChange, s.PipelineDealStatusChange, 
			s.PipelineTerritorySelectionChange, s.IsExclusiveChange, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0
;

GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimPipelineDealHistory] TO [ETLRole] AS [dbo];

GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimPipelineDealHistory] TO [DataServices]
    AS [dbo];
GO

