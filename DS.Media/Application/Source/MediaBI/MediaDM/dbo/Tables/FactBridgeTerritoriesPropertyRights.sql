CREATE TABLE [dbo].[FactBridgeTerritoriesPropertyRights] (
    [TerritoryTreeKey]  BIGINT           NOT NULL,
    [PropertyRightsKey] BIGINT           NOT NULL,
    [TerritoryTreeId]   INT              NOT NULL,
    [DesignatedRightId] INT              NULL,
    [HashKey]           VARBINARY (8000) NULL,
    [DeletedOn]         DATETIME         NULL,
    CONSTRAINT [PK_FactBridgeTerritoriesPropertyRights] PRIMARY KEY CLUSTERED ([PropertyRightsKey] ASC, [TerritoryTreeKey] ASC)
);



