CREATE TABLE [dbo].[Projection] (
    [Id]                   INT             NOT NULL,
    [ProjectionHeaderId]   INT             NOT NULL,
    [CustomerId]           INT             NOT NULL,
    [ProductId]            INT             NOT NULL,
    [TerritoryId]          INT             NOT NULL,
    [AnticipatedCcyId]     INT             NOT NULL,
    [AnticipatedAmount]    NUMERIC (16, 2) NOT NULL,
    [AnticipatedAmountUSD] NUMERIC (16, 2) NOT NULL,
    [PipelineDealId]       INT             DEFAULT ((0)) NULL,
    [TargetCurrencyId]     INT             DEFAULT ((0)) NULL,
    [TargetAmount]         NUMERIC (16, 2) DEFAULT ((0)) NOT NULL,
    [TargetAmountUSD]      NUMERIC (16, 2) DEFAULT ((0)) NOT NULL,
    [StatusId]             INT             DEFAULT ((0)) NOT NULL,
    [CreatedDate]          DATETIME        NOT NULL,
    [CreatedBy]            INT             NOT NULL,
    [UpdatedDate]          DATETIME        NULL,
    [UpdatedBy]            INT             NULL,
    [AppearAmountInTotal] BIT NULL, 
    CONSTRAINT [PK_Projection_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);









