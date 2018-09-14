CREATE TABLE [dbo].[FactBudgets] (
    [BudgetKey]          BIGINT           NOT NULL,
    [ProjectionKey]      BIGINT           NOT NULL,
    [ProjectionYear]     CHAR (4)         NOT NULL,
    [Budget]             DECIMAL (38, 2)  NULL,
    [PreviousYearActual] DECIMAL (38, 2)  NULL,
    [Forecast]           DECIMAL (38, 2)  NULL,
    [MonthsToExpiry]     INT              NULL,
    [HashKey]            VARBINARY (8000) NULL,
    [DeletedOn]          DATETIME         NULL,
    CONSTRAINT [FK_FactBudgets_DimBudget] FOREIGN KEY ([BudgetKey]) REFERENCES [dbo].[DimBudget] ([BudgetKey]),
    CONSTRAINT [FK_FactBudgets_DimProjectionProperty] FOREIGN KEY ([ProjectionKey]) REFERENCES [dbo].[DimProjection] ([ProjectionKey]),
    CONSTRAINT [FK_FactBudgets_DimProjectionYear] FOREIGN KEY ([ProjectionYear]) REFERENCES [dbo].[DimProjectionYear] ([ProjectionYear])
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactBudgets] TO [DataServices]
    AS [dbo];

