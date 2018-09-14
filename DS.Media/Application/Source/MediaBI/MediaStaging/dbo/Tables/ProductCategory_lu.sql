CREATE TABLE [dbo].[ProductCategory_lu] (
    [Id]                    INT          NOT NULL,
    [Description]           VARCHAR (50) NULL,
    [ProductCategoryTypeId] INT          NULL,
    [StatusId]              INT          NULL,
    [CreatedDate]           DATETIME     NULL,
    [CreatedBy]             INT          NULL,
    [UpdatedDate]           DATETIME     NULL,
    [UpdatedBy]             INT          NULL,
    CONSTRAINT [PK_ProductCategory_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



