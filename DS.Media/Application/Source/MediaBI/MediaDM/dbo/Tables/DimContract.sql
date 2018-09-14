CREATE TABLE [dbo].[DimContract] (
    [ContractKey]          BIGINT           NOT NULL,
    [ContractDescription]  VARCHAR (62)     NOT NULL,
    [AgreementType]        VARCHAR (30)     NOT NULL,
    [AgreementBy]          VARCHAR (50)     NOT NULL,
    [ContractType]         VARCHAR (255)    NOT NULL,
    [LicensorParty]        VARCHAR (80)     NOT NULL,
    [LegalOnline]          INT              NOT NULL,
    [LegalContractStatus]  VARCHAR (50)     NOT NULL,
    [Licensor]             VARCHAR (50)     NOT NULL,
    [ContractText]         VARCHAR (1024)   NOT NULL,
    [ContractInstructions] VARCHAR (1024)   NULL,
    [IssueSite]            VARCHAR (50)     NULL,
    [City]                 VARCHAR (50)     NOT NULL,
    [Region]               VARCHAR (50)     NOT NULL,
    [Country]              VARCHAR (50)     NOT NULL,
    [LegalOnlineContact]   VARCHAR (120)    DEFAULT ('N/A') NOT NULL,
    [IssueSiteId]          INT              NOT NULL,
    [HashKey]              VARBINARY (8000) NOT NULL,
    [DeletedOn]            DATETIME         NULL,
    CONSTRAINT [PK_DimContract] PRIMARY KEY CLUSTERED ([ContractKey] ASC)
);












GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimContract] TO [DataServices]
    AS [dbo];

