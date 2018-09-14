CREATE TABLE [dbo].[DimPropertyVersion] (
    [VersionKey]       BIGINT           NOT NULL,
    [PropertyKey]      BIGINT           NOT NULL,
    [BroadcastType]    VARCHAR (50)     NOT NULL,
    [VersionName]      VARCHAR (70)     NOT NULL,
    [AvailabilityDate] DATETIME         NULL,
    [HashKey]          VARBINARY (8000) NOT NULL,
    [DeletedOn]        DATETIME         NULL,
    CONSTRAINT [PK_DimPropertyVersion] PRIMARY KEY CLUSTERED ([VersionKey] ASC, [PropertyKey] ASC)
);

