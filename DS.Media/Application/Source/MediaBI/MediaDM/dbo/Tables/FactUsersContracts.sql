CREATE TABLE [dbo].[FactUsersContracts] (
    [UserContractKey]  BIGINT           NULL,
    [UserKey]          BIGINT           NULL,
    [CountOfContracts] INT              NOT NULL,
    [HashKey]          VARBINARY (8000) NULL,
    [DeletedOn]        DATETIME         NULL,
    CONSTRAINT [FK_FactUsersContracts_DimUser] FOREIGN KEY ([UserKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactUsersContracts_DimUserContract] FOREIGN KEY ([UserContractKey]) REFERENCES [dbo].[DimUserContract] ([UserContractKey])
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactUsersContracts] TO [DataServices]
    AS [dbo];

