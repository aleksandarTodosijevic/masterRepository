CREATE TABLE [dbo].[OrderDetailProductClient] (
    [Id]            INT      NOT NULL,
    [OrderDetailId] INT      NOT NULL,
    [ProductId]     INT      NOT NULL,
    [ClientId]      INT      NOT NULL,
    [StatusId]      INT      NOT NULL,
    [CreatedDate]   DATETIME NOT NULL,
    [CreatedBy]     INT      NOT NULL,
    [UpdatedDate]   DATETIME NULL,
    [UpdatedBy]     INT      NULL,
    CONSTRAINT [PK_OrderDetailProductClient] PRIMARY KEY CLUSTERED ([Id] ASC)
);



