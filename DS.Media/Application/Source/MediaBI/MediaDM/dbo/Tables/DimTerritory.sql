CREATE TABLE [dbo].[DimTerritory] (
    [TerritoryTreeKey]       BIGINT        NOT NULL,
    [TerritoryTreeId]        INT           NOT NULL,
    [TerritoryTreeParentId] INT            NULL,
    [TerritoryName]           VARCHAR (50) NULL,
	[HashKey]           VARBINARY (8000)   NOT NULL,
    [DeletedOn]         DATETIME           NULL,
	CONSTRAINT [PK_DimTerritory] PRIMARY KEY CLUSTERED ([TerritoryTreeKey] ASC)
);

