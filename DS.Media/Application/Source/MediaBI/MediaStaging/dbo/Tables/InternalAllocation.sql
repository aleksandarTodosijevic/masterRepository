CREATE TABLE [dbo].[InternalAllocation] (
    [Id]                  INT             NOT NULL,
    [ParentId]            INT             NULL,
    [IncomeTypeId]        INT             NOT NULL,
    [FeeTypeId]           INT             NOT NULL,
    [OrderHeaderId]       INT             NOT NULL,
    [OrderInvoiceId]      INT             NOT NULL,
    [ProductId]           INT             NOT NULL,
    [CurrencyId]          INT             NOT NULL,
    [Amount]              NUMERIC (16, 2) NOT NULL,
    [OriginalAmount]      NUMERIC (16, 2) NOT NULL,
    [OriginalFeeTypeId]   INT             NOT NULL,
    [USDollarEquivalent]  NUMERIC (16, 2) NOT NULL,
    [InvoiceDueDate]      DATETIME        NOT NULL,
    [ProjectionYear]      CHAR (4)        NOT NULL,
    [TerritoryId]         INT             NOT NULL,
    [RightsDescription]   VARCHAR (1000)  NULL,
    [InvoiceWasCancelled] BIT             NOT NULL,
    [StatusId]            INT             NOT NULL,
    [CreatedDate]         DATETIME        NOT NULL,
    [CreatedBy]           INT             NOT NULL,
    [UpdatedDate]         DATETIME        NULL,
    [UpdatedBy]           INT             NULL,
    CONSTRAINT [PK_InternalAllocation] PRIMARY KEY CLUSTERED ([Id] ASC)
);



