CREATE TABLE [dbo].[FactOrderDetails] (
    [ContractKey]          BIGINT           NULL,
    [PropertyKey]          BIGINT           NULL,
    [ProjectionKey]        BIGINT           NULL,
    [DealPropertyKey]      BIGINT           NULL,
    [DealKey]              BIGINT           NULL,
    [CustomerContactKey]   BIGINT           NULL,
    [DealCreatedByKey]     BIGINT           NULL,
    [DealCreatedOnDateKey] INT              NULL,
    [DealUpdatedByKey]     BIGINT           NULL,
    [DealUpdatedOnDateKey] INT              NULL,
    [HashKey]              VARBINARY (8000) NULL,
    [DeletedOn]            DATETIME         NULL,
    CONSTRAINT [FK_FactOrderDetails_CustomerContact] FOREIGN KEY ([CustomerContactKey]) REFERENCES [dbo].[DimCustomerContact] ([CustomerContactKey]),
    CONSTRAINT [FK_FactOrderDetails_DealCreatedBy] FOREIGN KEY ([DealCreatedByKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactOrderDetails_DealCreatedOnDate] FOREIGN KEY ([DealCreatedOnDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactOrderDetails_DealUpdatedBy] FOREIGN KEY ([DealUpdatedByKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactOrderDetails_DealUpdatedOnDate] FOREIGN KEY ([DealUpdatedOnDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactOrderDetails_DimContract] FOREIGN KEY ([ContractKey]) REFERENCES [dbo].[DimContract] ([ContractKey]),
    CONSTRAINT [FK_FactOrderDetails_DimDeal] FOREIGN KEY ([DealKey]) REFERENCES [dbo].[DimDeal] ([DealKey]),
    CONSTRAINT [FK_FactOrderDetails_DimDealProperty] FOREIGN KEY ([DealPropertyKey]) REFERENCES [dbo].[DimDealProperty] ([DealPropertyKey]),
    CONSTRAINT [FK_FactOrderDetails_DimProjectionProperty] FOREIGN KEY ([ProjectionKey]) REFERENCES [dbo].[DimProjection] ([ProjectionKey]),
    CONSTRAINT [FK_FactOrderDetails_DimProperty] FOREIGN KEY ([PropertyKey]) REFERENCES [dbo].[DimProperty] ([PropertyKey])
);












GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactOrderDetails] TO [DataServices]
    AS [dbo];

