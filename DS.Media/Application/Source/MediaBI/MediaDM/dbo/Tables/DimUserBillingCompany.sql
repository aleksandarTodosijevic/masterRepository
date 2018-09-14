CREATE TABLE [dbo].[DimUserBillingCompany] (
    [UserBillingCompanyKey] BIGINT           NOT NULL,
    [BillingCompanyId]      INT              NOT NULL,
    [BillingCompany]        VARCHAR (80)     NOT NULL,
    [HashKey]               VARBINARY (8000) NOT NULL,
    [DeletedOn]             DATETIME         NULL,
    CONSTRAINT [PK_DimUserBillingCompany] PRIMARY KEY CLUSTERED ([UserBillingCompanyKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimUserBillingCompany] TO [DataServices]
    AS [dbo];

