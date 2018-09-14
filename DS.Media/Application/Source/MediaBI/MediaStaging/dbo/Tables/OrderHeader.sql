CREATE TABLE [dbo].[OrderHeader] (
    [Id]                      INT      NOT NULL,
    [SalesCategoryId]         INT      NOT NULL,
    [SalesAreaId]             INT      NOT NULL,
    [CustomerId]              INT      NOT NULL,
    [TerritoryId]             INT      NOT NULL,
    [OrderStatusId]           INT      NOT NULL,
    [TargetOrderStatusId]     INT      NULL,
    [ProcessedDate]           DATETIME NOT NULL,
    [ProcessedDateLast]       DATETIME NOT NULL,
    [ApprovalNeeded]          BIT      NOT NULL,
    [RuleBitSum]              INT      NOT NULL,
    [RuleValidationDate]      DATETIME NULL,
    [ContractGeneratedMethod] BIT      NOT NULL,
    [RightsInfoUpdatedDate]   DATETIME NOT NULL,
    [StatusId]                INT      NOT NULL,
    [CreatedDate]             DATETIME NOT NULL,
    [CreatedBy]               INT      NOT NULL,
    [UpdatedDate]             DATETIME NULL,
    [UpdatedBy]               INT      NULL,
    [SourcePipelineDealId]    INT      NULL,
    CONSTRAINT [PK_OrderHeader_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);









