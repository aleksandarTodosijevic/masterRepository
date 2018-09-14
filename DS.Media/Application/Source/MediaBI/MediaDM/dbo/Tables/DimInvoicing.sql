CREATE TABLE [dbo].[DimInvoicing] (
    [InvoicingKey]             BIGINT           NOT NULL,
    [SOLItem]                  VARCHAR (11)     NOT NULL,
    [BillingCode]              VARCHAR (20)     NOT NULL,
    [InvoiceCategory]          VARCHAR (20)     NOT NULL,
    [InvoiceStatus]            VARCHAR (20)     NOT NULL,
    [InterfaceStatus]          VARCHAR (20)     NOT NULL,
    [FeeType]                  VARCHAR (50)     NOT NULL,
    [OrderHeaderId]            INT              NOT NULL,
    [OrderDetailId]            INT              NOT NULL,
    [InstallmentNo]            INT              NULL,
    [CurrencyCode]             CHAR (3)         NOT NULL,
    [ProjectionYear]           CHAR (4)         NULL,
    [SAPLineItemNumber]        VARCHAR (20)     NULL,
    [SAPSalesOrderNumber]      VARCHAR (20)     NULL,
    [InvoiceDueDate]           DATETIME         NULL,
    [SAPInvoiceCreatedDate]    DATETIME         NULL,
    [SAPDocumentDate]          DATETIME         NULL,
    [InvoiceUpdatedDate]       DATETIME         NULL,
    [InvoiceInstructions]      VARCHAR (2048)   NULL,
    [InvoiceDescription]       VARCHAR (2048)   NULL,
    [InvoiceReferenceNumber]   VARCHAR (20)     NULL,
    [RightsTechIndicator]      VARCHAR (10)     NOT NULL,
    [CancellationStatus]       VARCHAR (13)     NOT NULL,
    [City]                     VARCHAR (50)     NOT NULL,
    [Region]                   VARCHAR (50)     NOT NULL,
    [Country]                  VARCHAR (50)     NOT NULL,
    [AccountingDocumentNumber] VARCHAR (10)     NULL,
    [ClearingDocumentNumber]   VARCHAR (20)     NULL,
    [ClearingDocumentDate]     DATE             NULL,
    [SOLNumber]                VARCHAR (10)     DEFAULT ('N/A') NOT NULL,
    [SAP_BILLING_STATUS]       VARCHAR (20)     NULL,
    [IsDataMartDueDate]        CHAR (3)         DEFAULT ('N/A') NOT NULL,
    [IssueSite]                VARCHAR (50)     DEFAULT ('N/A') NOT NULL,
    [BillingCompanyId]         INT              DEFAULT ((-1)) NOT NULL,
    [BillingCompany]           VARCHAR (80)     DEFAULT ('Unknown') NOT NULL,
    [HashKey]                  VARBINARY (8000) NOT NULL,
    [DeletedOn]                DATETIME         NULL,
    CONSTRAINT [PK_DimInvoice] PRIMARY KEY CLUSTERED ([InvoicingKey] ASC)
);









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimInvoicing] TO [DataServices]
    AS [dbo];

