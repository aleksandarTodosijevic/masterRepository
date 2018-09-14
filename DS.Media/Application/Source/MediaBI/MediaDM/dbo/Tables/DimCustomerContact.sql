CREATE TABLE [dbo].[DimCustomerContact] (
    [CustomerContactKey]      BIGINT           NOT NULL,
    [SourceCustomerId]        INT              NOT NULL,
    [SourceContactId]         INT              NOT NULL,
    [SourceCustomerAddressId] INT              NOT NULL,
    [CustomerNo]              INT              NOT NULL,
    [CustomerName]            VARCHAR (80)     NOT NULL,
    [CustomerShortName]       VARCHAR (20)     NOT NULL,
    [ContactName]             VARCHAR (35)     NOT NULL,
    [ProjectionTerritory]     VARCHAR (50)     NOT NULL,
    [SAPCustomerNumber]       VARCHAR (10)     NOT NULL,
    [SAPPayerNumber]          VARCHAR (10)     NOT NULL,
    [SOLId]                   INT              NOT NULL,
    [RightsSelection]         VARCHAR (2048)   DEFAULT ('N/A') NOT NULL,
    [TerritorySelection]      VARCHAR (2048)   DEFAULT ('N/A') NOT NULL,
    [LanguageSelection]       VARCHAR (2048)   DEFAULT ('N/A') NOT NULL,
    [NumberOfTransmissions]   INT              DEFAULT ((0)) NOT NULL,
	[NumberOfTransmissionsName] VARCHAR(30)	   DEFAULT ('N/A') NOT NULL,
    [HashKey]                 VARBINARY (8000) NOT NULL,
    [DeletedOn]               DATETIME         NULL,
    CONSTRAINT [PK_DimCustomerContact] PRIMARY KEY CLUSTERED ([CustomerContactKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimCustomerContact] TO [DataServices]
    AS [dbo];

