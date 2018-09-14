CREATE TABLE [dbo].[TerritoryRegion_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [Code]        VARCHAR (3)  NOT NULL,
    [TerritoryId] INT          NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_TerritoryRegion_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);


