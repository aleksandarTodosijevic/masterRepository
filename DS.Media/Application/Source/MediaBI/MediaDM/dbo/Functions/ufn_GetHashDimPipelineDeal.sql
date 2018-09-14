Create FUNCTION [dbo].[ufn_GetHashDimPipelineDeal]
(
	 @PipelineDealKey BIGINT
	,@PipelineDealId INT
	,@SalesProgress NUMERIC(9,2)
	,@Reason VARCHAR(250)
	,@PipelineDealStatus VARCHAR(7)
	,@CreatedDate DATE
	,@UpdatedDate DATE
	,@PipelineTerritorySelection VARCHAR(2048)
	,@CreatedBy VARCHAR(100)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @PipelineDealKey AS PipelineDealKey
	,@PipelineDealId AS PipelineDealId
	,@SalesProgress AS SalesProgress
	,@Reason AS Reason
	,@PipelineDealStatus AS PipelineDealStatus
	,@CreatedDate AS CreatedDate
	,@UpdatedDate AS UpdatedDate
	,@PipelineTerritorySelection AS PipelineTerritorySelection
	,@CreatedBy AS CreatedBy
	FOR XML RAW('r')))
END