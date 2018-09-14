CREATE TABLE [dbo].[DimBudget] (
    [BudgetKey]                  BIGINT           NOT NULL,
    [SaleType]                   NVARCHAR (250)   NULL,
    [DateOfExpiry]               DATETIME2 (3)    NULL,
    [MonthsToExpiry]             INT              NULL,
    [SourceBudgetId]             INT              NOT NULL,
    [YOYGrowth]                  NVARCHAR (50)    DEFAULT ('N/A') NOT NULL,
    [PriorityOfEngagementRating] DECIMAL (18, 2)  DEFAULT ((0)) NOT NULL,
    [EffectiveDateQuarter]       NVARCHAR (10)    DEFAULT ('N/A') NOT NULL,
    [HashKey]                    VARBINARY (8000) NOT NULL,
    [DeletedOn]                  DATETIME         NULL,
    CONSTRAINT [PK_DimBudget] PRIMARY KEY CLUSTERED ([BudgetKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimBudget] TO [DataServices]
    AS [dbo];

