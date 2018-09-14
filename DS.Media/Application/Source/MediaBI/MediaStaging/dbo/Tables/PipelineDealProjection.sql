CREATE TABLE [dbo].[PipelineDealProjection] (
    [Id]                             INT             NOT NULL,
    [PipelineDealId]                 INT             NOT NULL,
    [ProjectionId]                   INT             NOT NULL,
    [AnticipatedCcyId]               INT             NOT NULL,
    [AnticipatedAmount]              NUMERIC (16, 2) NOT NULL,
    [AnticipatedAmountUSD]           NUMERIC (16, 2) NOT NULL,
    [TargetCurrencyId]               INT             NULL,
    [TargetAmount]                   NUMERIC (16, 2) NOT NULL,
    [TargetAmountUSD]                NUMERIC (16, 2) NOT NULL,
    [AppearAmountInTotalHasPriority] BIT             NOT NULL,
    [StatusId]                       INT             NOT NULL,
    [CreatedDate]                    DATETIME        NOT NULL,
    [CreatedBy]                      INT             NOT NULL,
    [UpdatedDate]                    DATETIME        NULL,
    [UpdatedBy]                      INT             NULL
);

