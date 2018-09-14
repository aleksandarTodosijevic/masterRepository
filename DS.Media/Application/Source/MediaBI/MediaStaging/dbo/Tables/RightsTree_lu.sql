CREATE TABLE [dbo].[RightsTree_lu] (
    [Id]               INT      NOT NULL,
    [ParentId]         INT      NULL,
    [RightsId]         INT      NOT NULL,
    [TopGroupParentId] INT      NOT NULL,
    [StatusId]         INT      NOT NULL,
    [CreatedDate]      DATETIME NOT NULL,
    [CreatedBy]        INT      NOT NULL,
    [UpdatedDate]      DATETIME NULL,
    [UpdatedBy]        INT      NULL,
    CONSTRAINT [PK_RightsTree_lu] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



