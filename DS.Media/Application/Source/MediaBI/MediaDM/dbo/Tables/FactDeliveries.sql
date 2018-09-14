CREATE TABLE [dbo].[FactDeliveries] (
    [DeliveryKey]   BIGINT           NULL,
    [PropertyKey]   BIGINT           NULL,
    [ProjectionKey] BIGINT           NULL,
    [DealKey]       BIGINT           NULL,
    [HashKey]       VARBINARY (8000) NULL,
    [DeletedOn]     DATETIME         NULL,
    CONSTRAINT [FK_FactDeliveries_DimDeal] FOREIGN KEY ([DealKey]) REFERENCES [dbo].[DimDeal] ([DealKey]),
    CONSTRAINT [FK_FactDeliveries_DimDelivery] FOREIGN KEY ([DeliveryKey]) REFERENCES [dbo].[DimDelivery] ([DeliveryKey]),
    CONSTRAINT [FK_FactDeliveries_DimProjection] FOREIGN KEY ([ProjectionKey]) REFERENCES [dbo].[DimProjection] ([ProjectionKey]),
    CONSTRAINT [FK_FactDeliveries_DimProperty] FOREIGN KEY ([PropertyKey]) REFERENCES [dbo].[DimProperty] ([PropertyKey])
);










GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactDeliveries] TO [DataServices]
    AS [dbo];

