CREATE TABLE [dbo].[SAPImportedInvoices] (
    [Id]                 INT           NOT NULL,
    [SOL_NUMBER]         VARCHAR (200) NULL,
    [SAP_INVOICE]        VARCHAR (200) NULL,
    [SAP_INV_ITEM]       VARCHAR (200) NULL,
    [SAP_INV_DATE]       VARCHAR (200) NULL,
    [SAP_ACCTG_DOC]      VARCHAR (200) NULL,
    [SAP_FISCAL_YR]      VARCHAR (200) NULL,
    [SAP_INV_DUE_DATE]   VARCHAR (200) NULL,
    [SAP_CLEAR_DOC]      VARCHAR (200) NULL,
    [SAP_CLEAR_DATE]     VARCHAR (200) NULL,
    [InvoiceId]          INT           NULL,
    [InvoiceType]        VARCHAR (1)   NULL,
    [BillingStatusId]    INT           NULL,
    [InterfaceError]     BIT           NOT NULL,
    [SAPExtractFilesId]  INT           NOT NULL,
    [ProcessedDate]      DATETIME      NULL,
    [StatusId]           INT           NOT NULL,
    [CreatedDate]        DATETIME      NOT NULL,
    [CreatedBy]          INT           NOT NULL,
    [UpdatedDate]        DATETIME      NULL,
    [UpdatedBy]          INT           NULL,
    [SAP_BILLING_STATUS] VARCHAR (200) NULL
);





