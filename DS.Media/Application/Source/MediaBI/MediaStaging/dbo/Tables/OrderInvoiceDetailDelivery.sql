CREATE TABLE [dbo].[OrderInvoiceDetailDelivery] (
    [Id]                    INT             NULL,
    [OrderDetailDeliveryId] INT             NOT NULL,
    [OrderInvoiceDetailId]  INT             NULL,
    [Amount]                NUMERIC (16, 2) NULL,
    [Quantity]              NUMERIC (16, 2) NULL,
    [StatusId]              INT             NULL,
    [CreatedDate]           DATETIME        NULL,
    [CreatedBy]             INT             NULL,
    [UpdatedDate]           DATETIME        NULL,
    [UpdatedBy]             INT             NULL
);



