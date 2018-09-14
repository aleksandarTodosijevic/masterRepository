CREATE TABLE [dbo].[FactBridgeRightsPropertyRights] (
    [RightsTreeKey]     BIGINT           NOT NULL,
    [PropertyRightsKey] BIGINT           NOT NULL,
    [RightsTreeId]      INT              NOT NULL,
    [DesignatedRightId] INT              NULL,
    [HashKey]           VARBINARY (8000) NULL,
    [DeletedOn]         DATETIME         NULL,
    CONSTRAINT [PK_FactBridgeRightsPropertyRights] PRIMARY KEY CLUSTERED ([PropertyRightsKey] ASC, [RightsTreeKey] ASC)
);

