CREATE TABLE [dbo].[FactBridgeTerritoriesPipelineDeals] (
    [TerritoryTreeKey] BIGINT           NULL,
    [PipelineDealKey]  BIGINT           NULL,
    [TerritoryTreeId]  INT              NOT NULL,
    [PipelineDealId]   INT              NULL,
    [HashKey]          VARBINARY (8000) NULL,
    [DeletedOn]        DATETIME         NULL
);

