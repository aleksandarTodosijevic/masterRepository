CREATE TABLE [dbo].[DimUserContract] (
    [UserContractKey]            BIGINT           NOT NULL,
    [BillingCompany]             VARCHAR (80)     NOT NULL,
    [LicensorParty]              VARCHAR (80)     NOT NULL,
    [IssueSiteStatusId]          INT              NOT NULL,
    [IssueSite]                  VARCHAR (80)     NOT NULL,
    [SelectedLicensingCompanies] VARCHAR (163)    NOT NULL,
    [LegalOnlineContact]         VARCHAR (120)    NOT NULL,
    [HashKey]                    VARBINARY (8000) NOT NULL,
    [DeletedOn]                  DATETIME         NULL,
    CONSTRAINT [PK_DimUserContract] PRIMARY KEY CLUSTERED ([UserContractKey] ASC)
);


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimUserContract] TO [DataServices]
    AS [dbo];
GO


