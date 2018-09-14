


CREATE VIEW [dbo].[Pipeline Deal History]
AS
SELECT 
	[PipelineDealHistoryKey] AS [Pipeline Deal History Key],
	[PipelineDealId] AS [Pipeline Deal Id (History)],
    [SalesProgress] AS [Sales Progress (History)],
    [Reason] AS [Latest Update (History)],
    [PipelineDealStatus] AS [Pipeline Deal Status (History)],
    [CreatedDate] AS [Pipeline Deal Created Date (History)],
    [UpdatedDate] AS [Pipeline Deal Updated Date (History)],
    [PipelineTerritorySelection] AS [Pipeline Deal Territory Selection (History)],
    [DescendingOrderOfChanges] AS [Order Of Changes],
	[CreatedBy] AS [Created By (History)],
	[IsExclusive] AS [Is Exclusive (History)],
	[SalesProgressChange] AS [Sales Progress (History) Change],
	[ReasonChange] AS [Latest Update (History) Change],
	[PipelineDealStatusChange] AS [Pipeline Deal Status (History) Change],
	[PipelineTerritorySelectionChange] AS [Pipeline Deal Territory Selection (History) Change], 
	[IsExclusiveChange] AS [Is Exclusive (History) Change]
  FROM [dbo].[DimPipelineDealHistory]
GO


