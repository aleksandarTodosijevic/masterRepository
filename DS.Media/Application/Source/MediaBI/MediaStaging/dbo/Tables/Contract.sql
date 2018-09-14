CREATE TABLE [dbo].[Contract] (
    [Id]                        INT            NOT NULL,
    [Description]               VARCHAR (50)   NOT NULL,
    [LegalContractId]           INT            NULL,
    [ContractStatusId]          INT            NULL,
    [ContractStatusUpdatedDate] DATETIME       NULL,
    [AgreementTypeId]           INT            NULL,
    [ContractIssueCategoryId]   INT            NULL,
    [IssueSiteId]               INT            NULL,
    [ContractTypeId]            INT            NULL,
    [CustomerAddressId]         INT            NULL,
    [CustomerContactid]         INT            NULL,
    [ContractText]              VARCHAR (1024) NULL,
    [ContractInstructions]      VARCHAR (1024) NULL,
    [LicensorId]                INT            NOT NULL,
    [ClientId]                  INT            NOT NULL,
    [StatusId]                  INT            NOT NULL,
    [CreatedDate]               DATETIME       NOT NULL,
    [CreatedBy]                 INT            NOT NULL,
    [UpdatedDate]               DATETIME       NULL,
    [UpdatedBy]                 INT            NULL,
    CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED ([Id] ASC)
);







