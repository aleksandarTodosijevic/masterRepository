CREATE TABLE [dbo].[FactProjections] (
    [ProjectionYear]           CHAR (4)         NOT NULL,
    [SalesAreaKey]             BIGINT           NOT NULL,
    [IncomeTypeKey]            BIGINT           NOT NULL,
    [PropertyKey]              BIGINT           NOT NULL,
    [ProjectionKey]            BIGINT           NOT NULL,
    [CustomerContactKey]       BIGINT           NOT NULL,
    [ProjectionTerritoryKey]   BIGINT           NOT NULL,
    [CurrencyKey]              BIGINT           NOT NULL,
    [ProjectionAnticipatedKey] BIGINT           NULL,
    [PipelineDealKey]          BIGINT           NULL,
    [AnticipatedAmount]        MONEY            NOT NULL,
    [AnticipatedAmountUSD]     MONEY            NOT NULL,
    [ActualAmount]             MONEY            DEFAULT ((0)) NOT NULL,
    [ActualAmountUSD]          MONEY            DEFAULT ((0)) NOT NULL,
    [TargetAmount]             DECIMAL (18, 2)  DEFAULT ((0)) NOT NULL,
    [SalesProgress]            NUMERIC (9, 2)   NOT NULL,
    [TargetAmountUSD]          MONEY            DEFAULT ((0)) NOT NULL,
    [HashKey]                  VARBINARY (8000) NULL,
    [DeletedOn]                DATETIME         NULL,
    CONSTRAINT [FK_FactProjections_Currency] FOREIGN KEY ([CurrencyKey]) REFERENCES [dbo].[DimCurrency] ([CurrencyKey]),
    CONSTRAINT [FK_FactProjections_CustomerContact] FOREIGN KEY ([CustomerContactKey]) REFERENCES [dbo].[DimCustomerContact] ([CustomerContactKey]),
    CONSTRAINT [FK_FactProjections_DimProjectionAnticipated] FOREIGN KEY ([ProjectionAnticipatedKey]) REFERENCES [dbo].[DimProjectionAnticipated] ([ProjectionAnticipatedKey]),
    CONSTRAINT [FK_FactProjections_DimProjectionProperty] FOREIGN KEY ([ProjectionKey]) REFERENCES [dbo].[DimProjection] ([ProjectionKey]),
    CONSTRAINT [FK_FactProjections_IncomeType] FOREIGN KEY ([IncomeTypeKey]) REFERENCES [dbo].[DimIncomeType] ([IncomeTypeKey]),
    CONSTRAINT [FK_FactProjections_PipelineDeal] FOREIGN KEY ([PipelineDealKey]) REFERENCES [dbo].[DimPipelineDeal] ([PipelineDealKey]),
    CONSTRAINT [FK_FactProjections_ProjectionTerritory] FOREIGN KEY ([ProjectionTerritoryKey]) REFERENCES [dbo].[DimProjectionTerritory] ([ProjectionTerritoryKey]),
    CONSTRAINT [FK_FactProjections_ProjectionYear] FOREIGN KEY ([ProjectionYear]) REFERENCES [dbo].[DimProjectionYear] ([ProjectionYear]),
    CONSTRAINT [FK_FactProjections_Property] FOREIGN KEY ([PropertyKey]) REFERENCES [dbo].[DimProperty] ([PropertyKey]),
    CONSTRAINT [FK_FactProjections_SalesArea] FOREIGN KEY ([SalesAreaKey]) REFERENCES [dbo].[DimSalesArea] ([SalesAreaKey])
);


GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactProjections] TO [DataServices]
    AS [dbo];
GO




