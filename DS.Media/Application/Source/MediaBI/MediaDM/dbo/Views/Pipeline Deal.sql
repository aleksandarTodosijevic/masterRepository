
CREATE VIEW [Pipeline Deal]
AS
SELECT 
	[PipelineDealKey] AS [Pipeline Deal Key],
	[PipelineDealId] AS [Pipeline Deal Id],
    [SalesProgress] AS [Sales Progress],
    [Reason] AS [Latest Update],
    [PipelineDealStatus] AS [Pipeline Deal Status],
    [CreatedDate] AS [Pipeline Deal Created Date],
    [UpdatedDate] AS [Pipeline Deal Updated Date],
    [PipelineTerritorySelection] AS [Pipeline Deal Territory Selection],
	[CreatedBy] AS [Created By],
	[IsExclusive] AS [Is Exclusive]
  FROM [dbo].[DimPipelineDeal]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Pipeline Deal] TO [DataServices]
    AS [dbo];

