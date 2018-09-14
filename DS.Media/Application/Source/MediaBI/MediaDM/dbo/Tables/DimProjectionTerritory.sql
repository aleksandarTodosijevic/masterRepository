CREATE TABLE [dbo].[DimProjectionTerritory] (
    [ProjectionTerritoryKey]		BIGINT           NOT NULL,
    [SourceTerritoryId]				INT              NOT NULL,
    [TerritoryRegion]				VARCHAR (50)     NOT NULL,
    [TerritoryName]					VARCHAR (50)     NOT NULL,
	[TerritoryTreeId]				INT				 NULL,
	[TerritoryTreeParentId]			INT				 NULL,
    [HashKey]						VARBINARY (8000) NOT NULL,
    [DeletedOn]						DATETIME         NULL,
    CONSTRAINT [PK_DimProjectionTerritory] PRIMARY KEY CLUSTERED ([ProjectionTerritoryKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimProjectionTerritory] TO [DataServices]
    AS [dbo];

