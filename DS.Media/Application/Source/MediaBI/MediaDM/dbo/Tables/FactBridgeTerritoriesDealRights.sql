CREATE TABLE [dbo].[FactBridgeTerritoriesDealRights] (
    [TerritoryTreeKey]        BIGINT NULL,
    [DealRightsKey]           BIGINT NULL,
    [TerritoryTreeId]           INT    NOT NULL,
    [OrderDetailRightsDetailId] INT    NULL,
	[HashKey]                  VARBINARY (8000) NULL,
    [DeletedOn]                DATETIME         NULL,
);

