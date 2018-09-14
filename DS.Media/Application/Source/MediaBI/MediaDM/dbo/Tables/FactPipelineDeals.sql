CREATE TABLE [dbo].[FactPipelineDeals] (
    [PipelineDealHistoryKey] BIGINT           NOT NULL,
    [PipelineDealKey]        BIGINT           NULL,
    [DealKey]                BIGINT           NOT NULL,
    [SalesProgress]          NUMERIC (13, 6)  NULL,
    [ProjectionKey]          BIGINT           NULL,
    [PropertyKey]            BIGINT           NULL,
    [CustomerContactKey]     BIGINT           NULL,
    [SalesAreaKey]           BIGINT           NULL,
    [HashKey]                VARBINARY (8000) NULL,
    [DeletedOn]              DATETIME         NULL,
    CONSTRAINT [FK_FactPipelineDeals_DimCustomerContact] FOREIGN KEY ([CustomerContactKey]) REFERENCES [dbo].[DimCustomerContact] ([CustomerContactKey]),
    CONSTRAINT [FK_FactPipelineDeals_DimDeal] FOREIGN KEY ([DealKey]) REFERENCES [dbo].[DimDeal] ([DealKey]),
    CONSTRAINT [FK_FactPipelineDeals_DimPipelineDealHistory] FOREIGN KEY ([PipelineDealHistoryKey]) REFERENCES [dbo].[DimPipelineDealHistory] ([PipelineDealHistoryKey]),
    CONSTRAINT [FK_FactPipelineDeals_DimProjection] FOREIGN KEY ([ProjectionKey]) REFERENCES [dbo].[DimProjection] ([ProjectionKey]),
    CONSTRAINT [FK_FactPipelineDeals_DimProperty] FOREIGN KEY ([PropertyKey]) REFERENCES [dbo].[DimProperty] ([PropertyKey])
);



GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactPipelineDeals] TO [DataServices]
    AS [dbo];
GO
