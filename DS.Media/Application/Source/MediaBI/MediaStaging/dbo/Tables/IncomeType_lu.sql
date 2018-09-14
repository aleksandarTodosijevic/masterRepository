CREATE TABLE [dbo].[IncomeType_lu] (
    [Id]              INT      NOT NULL,
    [SalesCategoryId] INT      NOT NULL,
    [FeeId]           INT      NOT NULL,
    [CreatesWTRecord] BIT      NOT NULL,
    [StatusId]        INT      NOT NULL,
    [CreatedDate]     DATETIME NOT NULL,
    [CreatedBy]       INT      NOT NULL,
    [UpdatedDate]     DATETIME NULL,
    [UpdatedBy]       INT      NULL,
    CONSTRAINT [PK_IncomeType_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



