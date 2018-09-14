CREATE TABLE [dbo].[TerritorySelection] (
    [TerritorySelectionId] INT      NOT NULL,
    [TerritoryTreeId]      INT      NOT NULL,
    [TerritoryId]          INT      NOT NULL,
    [StatusId]             INT      NOT NULL,
    [CreatedDate]          DATETIME NOT NULL,
    [CreatedBy]            INT      NOT NULL,
    [UpdatedDate]          DATETIME NULL,
    [UpdatedBy]            INT      NULL,
    CONSTRAINT [PK_TerritorySelection] PRIMARY KEY CLUSTERED ([TerritorySelectionId] ASC, [TerritoryTreeId] ASC)
);



