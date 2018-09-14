CREATE TABLE [dbo].[Fee_lu] (
    [Id]                INT          NOT NULL,
    [FeeTypeId]         INT          NULL,
    [Description]       VARCHAR (50) NOT NULL,
    [SAPMaterialNumber] INT          NOT NULL,
    [SAPAccountGroup]   CHAR (4)     NOT NULL,
    [StatusId]          INT          NOT NULL,
    [CreatedDate]       DATETIME     NOT NULL,
    [CreatedBy]         INT          NOT NULL,
    [UpdatedDate]       DATETIME     NULL,
    [UpdatedBy]         INT          NULL,
    CONSTRAINT [PK_Fee_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



