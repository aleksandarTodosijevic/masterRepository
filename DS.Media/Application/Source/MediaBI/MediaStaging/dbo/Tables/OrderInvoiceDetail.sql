CREATE TABLE [dbo].[OrderInvoiceDetail] (
    [Id]                 INT             NOT NULL,
    [OrderDetailId]      INT             NOT NULL,
    [OrderInvoiceId]     INT             NOT NULL,
    [Amount]             NUMERIC (16, 2) NULL,
    [USDollarEquivalent] NUMERIC (16, 2) NULL,
    [LocalAmount]        NUMERIC (16, 2) NULL,
    [ProjectionYear]     CHAR (4)        NULL,
    [SAPLineItemNumber]  VARCHAR (20)    NULL,
    [StatusId]           INT             NOT NULL,
    [CreatedDate]        DATETIME        NOT NULL,
    [CreatedBy]          INT             NOT NULL,
    [UpdatedDate]        DATETIME        NULL,
    [UpdatedBy]          INT             NULL,
    CONSTRAINT [PK_OrderInvoiceDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE INDEX [IX_OrderInvoiceDetail_OrderDetailId] ON [dbo].[OrderInvoiceDetail] ([OrderDetailId]);