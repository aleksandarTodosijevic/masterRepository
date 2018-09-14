CREATE TABLE [dbo].[ContractIssueCategory_lu] (
    [Id]              INT          NOT NULL,
    [Description]     VARCHAR (50) NULL,
    [AgreementTypeId] INT          NULL,
    [SystemArea]      INT          NULL,
    [StatusId]        INT          NULL,
    [CreatedDate]     DATETIME     NULL,
    [CreatedBy]       INT          NULL,
    [UpdatedDate]     DATETIME     NULL,
    [UpdatedBy]       INT          NULL,
    CONSTRAINT [PK_ContractIssueCategory_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



