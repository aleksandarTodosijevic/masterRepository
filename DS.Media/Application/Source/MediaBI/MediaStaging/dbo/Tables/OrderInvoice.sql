﻿CREATE TABLE [dbo].[OrderInvoice] (
    [Id]                     INT              NOT NULL,
    [OrderHeaderId]          INT              NOT NULL,
    [BillingCodeId]          INT              NOT NULL,
    [FeeId]                  INT              NOT NULL,
    [CurrencyId]             INT              NULL,
    [Rate]                   NUMERIC (16, 5)  NULL,
    [PaymentStyle]           INT              NOT NULL,
    [UnitOfMeasureId]        INT              NULL,
    [Quantity]               NUMERIC (16, 2)  NULL,
    [TotalAmount]            NUMERIC (16, 2)  NULL,
    [LocalCcyId]             INT              NULL,
    [InvoiceDueDate]         DATETIME         NULL,
    [InvoiceDescription]     VARCHAR (2048)   NULL,
    [InvoiceCategoryId]      INT              NOT NULL,
    [InvoiceStatusId]        INT              NOT NULL,
    [InvoiceReferenceNumber] VARCHAR (20)     NULL,
    [SAPSalesOrderNumber]    VARCHAR (20)     NULL,
    [CommsInterfaceStatusId] INT              NOT NULL,
    [InvoiceWasProcessed]    BIT              NOT NULL,
    [InvoiceProcessedDate]   DATETIME         NULL,
    [InvoiceWasCancelled]    BIT              NOT NULL,
    [InvoiceInstructions]    VARCHAR (2048)   NULL,
    [IsLocked]               BIT              NOT NULL,
    [InstallmentNo]          INT              NULL,
    [CustomerAddressId]      INT              NULL,
    [CustomerContactId]      INT              NULL,
    [CreditedInvoiceId]      INT              NULL,
    [TransferToSAP]          DATETIME         NOT NULL,
    [TransferFileName]       VARCHAR (200)    NULL,
    [GroupGUID]              UNIQUEIDENTIFIER NULL,
    [StatusId]               INT              NOT NULL,
    [CreatedDate]            DATETIME         NOT NULL,
    [CreatedBy]              INT              NOT NULL,
    [UpdatedDate]            DATETIME         NULL,
    [UpdatedBy]              INT              NULL,
    [IsDataMartDueDate]      BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_OrderInvoice] PRIMARY KEY CLUSTERED ([Id] ASC)
);



