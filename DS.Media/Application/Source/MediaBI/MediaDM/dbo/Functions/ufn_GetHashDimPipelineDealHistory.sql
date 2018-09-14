CREATE FUNCTION [dbo].[ufn_GetHashDimPipelineDealHistory]
(
	 @PipelineDealHistoryKey BIGINT
	,@PipelineDealId INT
	,@SalesProgress NUMERIC(9,2)
	,@Reason VARCHAR(250)
	,@PipelineDealStatus VARCHAR(7)
	,@CreatedDate DATE
	,@UpdatedDate DATE
	,@PipelineTerritorySelection VARCHAR(2048)
	,@DescendingOrderOfChanges INT
	,@CreatedBy VARCHAR(100)
	,@SalesProgressChange CHAR(3)
	,@ReasonChange CHAR(3)
	,@PipelineDealStatusChange CHAR(3)
	,@PipelineTerritorySelectionChange CHAR(3)
	,@IsExclusiveChange CHAR(3)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @PipelineDealHistoryKey AS PipelineDealHistoryKey
	,@PipelineDealId AS PipelineDealId
	,@SalesProgress AS SalesProgress
	,@Reason AS Reason
	,@PipelineDealStatus AS PipelineDealStatus
	,@CreatedDate AS CreatedDate
	,@UpdatedDate AS UpdatedDate
	,@PipelineTerritorySelection AS PipelineTerritorySelection
	,@DescendingOrderOfChanges AS DescendingOrderOfChanges
	,@CreatedBy AS CreatedBy
	,@SalesProgressChange AS SalesProgressChange
	,@ReasonChange AS ReasonChange
	,@PipelineDealStatusChange AS PipelineDealStatusChange
	,@PipelineTerritorySelectionChange AS PipelineTerritorySelectionChange
	,@IsExclusiveChange AS IsExclusiveChange
	FOR XML RAW('r')))
END