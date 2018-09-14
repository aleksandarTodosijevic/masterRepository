CREATE TABLE [dbo].[OrderComment] (
    [Id]            INT            NOT NULL,
    [OrderHeaderId] INT            NOT NULL,
    [Description]   VARCHAR (3000) NOT NULL,
    [OrderPageId]   INT            NOT NULL,
    [StatusId]      INT            NOT NULL,
    [CreatedDate]   DATETIME       NOT NULL,
    [CreatedBy]     INT            NOT NULL,
    [UpdatedDate]   DATETIME       NULL,
    [UpdatedBy]     INT            NULL,
    CONSTRAINT [PK_OrderComment] PRIMARY KEY CLUSTERED ([Id] ASC)
);



