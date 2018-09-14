CREATE TABLE [dbo].[DimRights] (
    [RightsTreeKey]      BIGINT           NOT NULL,
    [RightsTreeId]       INT              NOT NULL,
    [RightsTreeParentId] INT              NULL,
    [RightsName]         VARCHAR (50)     NULL,
    [HashKey]            VARBINARY (8000) NOT NULL,
    [DeletedOn]          DATETIME         NULL,
    CONSTRAINT [PK_DimRights] PRIMARY KEY CLUSTERED ([RightsTreeKey] ASC)
);

