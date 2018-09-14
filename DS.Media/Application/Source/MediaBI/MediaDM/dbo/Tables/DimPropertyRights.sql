CREATE TABLE [dbo].[DimPropertyRights] (
    [PropertyRightsKey]      BIGINT           NOT NULL,
    [SourcePropertyRightsId] INT              NOT NULL,
    [RightsSelection]        VARCHAR (2048)   NOT NULL,
    [TerritorySelection]     VARCHAR (2048)   NOT NULL,
    [LanguageSelection]      VARCHAR (2048)   NOT NULL,
    [LicenseStartDate]       DATETIME         NULL,
    [LicenseEndDate]         DATETIME         NULL,
    [InPerpetuity]           VARCHAR (3)      NOT NULL,
    [HashKey]                VARBINARY (8000) NOT NULL,
    [DeletedOn]              DATETIME         NULL,
    CONSTRAINT [PK_DimDesignatedRight] PRIMARY KEY CLUSTERED ([PropertyRightsKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimPropertyRights] TO [DataServices]
    AS [dbo];

