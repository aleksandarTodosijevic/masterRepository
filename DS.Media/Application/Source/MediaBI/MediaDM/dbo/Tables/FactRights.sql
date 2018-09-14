CREATE TABLE [dbo].[FactRights] (
    [CustomerContactKey]   BIGINT           NOT NULL,
    [DealKey]              BIGINT           NOT NULL,
    [LicenseStartDateKey]  INT              NOT NULL,
    [LicenseEndDateKey]    INT              NOT NULL,
    [PropertyKey]          BIGINT           NOT NULL,
    [ProjectionKey]        BIGINT           NOT NULL,
    [DealPropertyKey]      BIGINT           NOT NULL,
    [DealRightsKey]        BIGINT           NOT NULL,
    [PropertyRightsKey]    BIGINT           NOT NULL,
    [DealCreatedByKey]     BIGINT           NOT NULL,
    [DealCreatedOnDateKey] INT              NOT NULL,
    [DealUpdatedByKey]     BIGINT           NOT NULL,
    [DealUpdatedOnDateKey] INT              NOT NULL,
	[EntertainmentShippedDateKey] INT			DEFAULT ((19000101)) NOT NULL,
	[RecognitionDateKey]	   INT				DEFAULT ((19000101)) NOT NULL,
    [HashKey]              VARBINARY (8000) NULL,
    [DeletedOn]            DATETIME         NULL,
    CONSTRAINT [FK_FactRights_CustomerContact] FOREIGN KEY ([CustomerContactKey]) REFERENCES [dbo].[DimCustomerContact] ([CustomerContactKey]),
    CONSTRAINT [FK_FactRights_Deal] FOREIGN KEY ([DealKey]) REFERENCES [dbo].[DimDeal] ([DealKey]),
    CONSTRAINT [FK_FactRights_DealCreatedBy] FOREIGN KEY ([DealCreatedByKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactRights_DealCreatedOnDate] FOREIGN KEY ([DealCreatedOnDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactRights_DealProperty] FOREIGN KEY ([DealPropertyKey]) REFERENCES [dbo].[DimDealProperty] ([DealPropertyKey]),
    CONSTRAINT [FK_FactRights_DealRights] FOREIGN KEY ([DealRightsKey]) REFERENCES [dbo].[DimDealRights] ([DealRightsKey]),
    CONSTRAINT [FK_FactRights_DealUpdatedBy] FOREIGN KEY ([DealUpdatedByKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactRights_DealUpdatedOnDate] FOREIGN KEY ([DealUpdatedOnDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactRights_DimProjectionProperty] FOREIGN KEY ([ProjectionKey]) REFERENCES [dbo].[DimProjection] ([ProjectionKey]),
    CONSTRAINT [FK_FactRights_LicenseEndDate] FOREIGN KEY ([LicenseEndDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactRights_LicenseStartDate] FOREIGN KEY ([LicenseStartDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactRights_Property] FOREIGN KEY ([PropertyKey]) REFERENCES [dbo].[DimProperty] ([PropertyKey]),
    CONSTRAINT [FK_FactRights_PropertyRights] FOREIGN KEY ([PropertyRightsKey]) REFERENCES [dbo].[DimPropertyRights] ([PropertyRightsKey]),
	CONSTRAINT [FK_FactRight_EntertainmentShippedDate] FOREIGN KEY ([EntertainmentShippedDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
	CONSTRAINT [FK_FactRight_RecognitionDate] FOREIGN KEY ([RecognitionDateKey]) REFERENCES [dbo].[DimDate] ([DateKey])
);









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactRights] TO [DataServices]
    AS [dbo];

