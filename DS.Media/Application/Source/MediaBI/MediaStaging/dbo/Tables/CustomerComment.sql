CREATE TABLE [dbo].[CustomerComment] (
    [Id]          INT            NOT NULL,
    [CustomerId]  INT            NOT NULL,
    [Description] VARCHAR (3000) NOT NULL,
    [StatusId]    INT            NOT NULL,
    [CreatedDate] DATETIME       NOT NULL,
    [CreatedBy]   INT            NOT NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    CONSTRAINT [PK_CustomerComment_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);







