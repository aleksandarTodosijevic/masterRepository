CREATE TABLE [dbo].[ProductCategoryType_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (50) NULL,
    [StatusId]    INT          NULL,
    [CreatedDate] DATETIME     NULL,
    [CreatedBy]   INT          NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_ProductCategoryType_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



