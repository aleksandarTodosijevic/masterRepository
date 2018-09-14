CREATE TABLE [dbo].[ProjectionTerritoryTree_lu] (
    [Id]                 INT      NOT NULL,
    [ParentId]           INT      NULL,
    [TerritoryId]        INT      NOT NULL,
    [ProjectionRegion]   BIT      NOT NULL,
    [ProjectionRegionId] INT      NOT NULL,
    [StatusId]           INT      NOT NULL,
    [CreatedDate]        DATETIME NOT NULL,
    [CreatedBy]          INT      NOT NULL,
    [UpdatedDate]        DATETIME NULL,
    [UpdatedBy]          INT      NULL,
    CONSTRAINT [PK_ProjectionTerritoryTree_lu] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



