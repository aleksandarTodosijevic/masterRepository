CREATE TABLE [dbo].[ProductContractClause] (
    [Id]                 INT              NOT NULL,
    [ProductId]          INT              NULL,
    [ContractClauseGUID] UNIQUEIDENTIFIER NULL,
    [ContractClauseName] VARCHAR (100)    NULL,
    [StatusId]           INT              NULL,
    [CreatedDate]        DATETIME         NULL,
    [CreatedBy]          INT              NULL,
    [UpdatedDate]        DATETIME         NULL,
    [UpdatedBy]          INT              NULL,
    CONSTRAINT [PK_ProductContractClause_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



