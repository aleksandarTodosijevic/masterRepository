CREATE TABLE [dbo].[OrderRightsInvoiceOrderDetail] (
    [Id]                   INT             NOT NULL,
    [OrderDetailId]        INT             NOT NULL,
    [OrderRightsInvoiceId] INT             NOT NULL,
    [Quantity]             NUMERIC (16, 2) NULL,
    [Amount]               NUMERIC (16, 2) NULL,
    [USDollarEquivalent]   NUMERIC (16, 2) NULL,
    [LocalAmount]          NUMERIC (16, 2) NULL,
    [ProjectionYear]       CHAR (4)        NULL,
    [SAPLineItemNumber]    VARCHAR (20)    NULL,
    [StatusId]             INT             NOT NULL,
    [CreatedDate]          DATETIME        NOT NULL,
    [CreatedBy]            INT             NOT NULL,
    [UpdatedDate]          DATETIME        NULL,
    [UpdatedBy]            INT             NULL,
    CONSTRAINT [PK_OrderRightsInvoiceOrderDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE INDEX [IX_OrderRightsInvoiceOrderDetail_OrderDetailId] ON [dbo].[OrderRightsInvoiceOrderDetail] ([OrderDetailId]);