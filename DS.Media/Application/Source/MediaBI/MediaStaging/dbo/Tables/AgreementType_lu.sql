CREATE TABLE [dbo].[AgreementType_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (30) NULL,
    [StatusId]    INT          NULL,
    [CreatedDate] DATETIME     NULL,
    [CreatedBy]   INT          NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_AgreementType_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



