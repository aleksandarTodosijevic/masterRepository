CREATE TABLE [dbo].[DimClient] (
    [ClientKey]          BIGINT           NOT NULL,
    [ClientNo]           VARCHAR (10)     NOT NULL,
    [ClientNoInt]        INT              NOT NULL,
    [ClientName]         VARCHAR (80)     NOT NULL,
    [ClientName2]        VARCHAR (80)     NOT NULL,
    [ClientFullName]     VARCHAR (160)    NOT NULL,
    [ClientAddress]      VARCHAR (309)    NOT NULL,
    [ClientCountry]      VARCHAR (80)     NOT NULL,
    [IsIMGClient]        VARCHAR (3)      NOT NULL,
    [IsProjectionClient] VARCHAR (3)      NOT NULL,
    [IsUltimateOwner]    VARCHAR (3)      NOT NULL,
    [HashKey]            VARBINARY (8000) NOT NULL,
    [DeletedOn]          DATETIME         NULL,
    CONSTRAINT [PK_DimClient] PRIMARY KEY CLUSTERED ([ClientKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimClient] TO [DataServices]
    AS [dbo];

