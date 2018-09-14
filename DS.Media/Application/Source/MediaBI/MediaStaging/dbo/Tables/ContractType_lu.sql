CREATE TABLE [dbo].[ContractType_lu] (
    [Id]          INT           NOT NULL,
    [Description] VARCHAR (255) NULL,
    [StatusId]    INT           NULL,
    [CreatedDate] DATETIME      NULL,
    [CreatedBy]   INT           NULL,
    [UpdatedDate] DATETIME      NULL,
    [UpdatedBy]   INT           NULL,
    CONSTRAINT [PK_ContractType_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



