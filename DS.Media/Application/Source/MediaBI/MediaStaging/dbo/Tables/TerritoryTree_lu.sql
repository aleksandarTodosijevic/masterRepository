CREATE TABLE [dbo].[TerritoryTree_lu] (
    [Id]          INT      NOT NULL,
    [ParentId]    INT      NULL,
    [TerritoryId] INT      NOT NULL,
    [StatusId]    INT      NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [CreatedBy]   INT      NOT NULL,
    [UpdatedDate] DATETIME NULL,
    [UpdatedBy]   INT      NULL,
    CONSTRAINT [PK_TerritoryTree_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



