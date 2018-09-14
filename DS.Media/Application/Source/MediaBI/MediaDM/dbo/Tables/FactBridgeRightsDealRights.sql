CREATE TABLE [dbo].[FactBridgeRightsDealRights] (
    [RightsTreeKey]             BIGINT           NULL,
    [DealRightsKey]             BIGINT           NULL,
    [RightsTreeId]              INT              NOT NULL,
    [OrderDetailRightsDetailId] INT              NULL,
    [HashKey]                   VARBINARY (8000) NULL,
    [DeletedOn]                 DATETIME         NULL
);

