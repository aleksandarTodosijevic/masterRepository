CREATE TABLE [dbo].[FactUserBillingCompanies] (
    [UserBillingCompanyKey]   BIGINT           NULL,
    [UserKey]                 BIGINT           NULL,
    [CountOfBillingCompanies] INT              NOT NULL,
    [HashKey]                 VARBINARY (8000) NULL,
    [DeletedOn]               DATETIME         NULL,
    CONSTRAINT [FK_FactUserBillingCompany_DimUser] FOREIGN KEY ([UserKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactUserBillingCompany_DimUserBillingCompany] FOREIGN KEY ([UserBillingCompanyKey]) REFERENCES [dbo].[DimUserBillingCompany] ([UserBillingCompanyKey])
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactUserBillingCompanies] TO [DataServices]
    AS [dbo];

