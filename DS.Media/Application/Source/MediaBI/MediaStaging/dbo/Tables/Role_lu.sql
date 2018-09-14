CREATE TABLE [dbo].[Role_lu] (
    [Id]          INT           NOT NULL,
    [Description] VARCHAR (50)  NOT NULL,
    [Comment]     VARCHAR (255) NULL,
    [StatusId]    INT           NOT NULL,
    [CreatedDate] DATETIME      NOT NULL,
    [CreatedBy]   INT           NOT NULL,
    [UpdatedDate] DATETIME      NULL,
    [UpdatedBy]   INT           NULL,
    CONSTRAINT [PK_Role_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



