CREATE TABLE [dbo].[InvoiceCategory_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [SAPCode]     VARCHAR (1)  NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_InvoiceCategory_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



