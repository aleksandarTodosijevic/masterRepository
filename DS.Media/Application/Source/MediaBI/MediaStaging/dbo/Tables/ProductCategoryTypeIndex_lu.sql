CREATE TABLE [dbo].[ProductCategoryTypeIndex_lu] (
    [Id]                    INT      NOT NULL,
    [ProductCategoryTypeId] INT      NULL,
    [ProductCategoryId]     INT      NULL,
    [StatusId]              INT      NULL,
    [CreatedDate]           DATETIME NULL,
    [CreatedBy]             INT      NULL,
    [UpdatedDate]           DATETIME NULL,
    [UpdatedBy]             INT      NULL,
    CONSTRAINT [PK_ProductCategoryTypeIndex_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



