CREATE TABLE [dbo].[DimDealRights] (
    [DealRightsKey]         BIGINT           NOT NULL,
    [SourceDealRightsId]    INT              NOT NULL,
    [DealRightsDescription] VARCHAR (2048)   NULL,
    [Exclusive]             VARCHAR (3)      NOT NULL,
    [TerritoryDescription]  VARCHAR (2048)   NULL,
    [LanguageDescription]   VARCHAR (2048)   NOT NULL,
    [LicenseStart]          DATETIME         NULL,
    [LicenseEnd]            DATETIME         NULL,
    [NumberOfTransmissions] INT              NOT NULL,
	[NumberOfTransmissionsName] VARCHAR(30)	 NOT NULL Default 'N/A',
    [InPerpetuity]          VARCHAR (3)      NOT NULL,
    [LicenseDuration]       INT              NOT NULL,
    [HashKey]               VARBINARY (8000) NOT NULL,
    [DeletedOn]             DATETIME         NULL,
    CONSTRAINT [PK_DimDealRights] PRIMARY KEY CLUSTERED ([DealRightsKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimDealRights] TO [DataServices]
    AS [dbo];

