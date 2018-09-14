CREATE TABLE [dbo].[OrderDetail] (
    [Id]                 INT      NOT NULL,
    [OrderHeaderId]      INT      NOT NULL,
    [ProductId]          INT      NOT NULL,
    [BillingCompanyId]   INT      NOT NULL,
    [ContractId]         INT      NULL,
    [NilRight]           BIT      NOT NULL,
    [DetailWasProcessed] BIT      NOT NULL,
    [StatusId]           INT      NOT NULL,
    [CreatedDate]        DATETIME NOT NULL,
    [CreatedBy]          INT      NOT NULL,
    [UpdatedDate]        DATETIME NULL,
    [UpdatedBy]          INT      NULL,
    CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE INDEX [IX_OrderDetail_OrderHeaderId] ON [dbo].[OrderDetail] ([OrderHeaderId]);