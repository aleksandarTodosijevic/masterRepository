CREATE TABLE [dbo].[ProductComment] (
    [Id]          INT            NOT NULL,
    [ProductId]   INT            NOT NULL,
    [Description] VARCHAR (3000) NOT NULL,
    [StatusId]    INT            NOT NULL,
    [CreatedDate] DATETIME       NOT NULL,
    [CreatedBy]   INT            NOT NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    CONSTRAINT [PK_ProductComment_Id] PRIMARY KEY CLUSTERED ([Id] ASC) 
);



