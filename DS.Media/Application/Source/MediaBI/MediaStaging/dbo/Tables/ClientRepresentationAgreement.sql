CREATE TABLE [dbo].[ClientRepresentationAgreement] (
    [Id]                        INT      NOT NULL,
    [ClientId]                  INT      NOT NULL,
    [RepresentationAgreementId] INT      NOT NULL,
    [StatusId]                  INT      NOT NULL,
    [CreatedDate]               DATETIME NOT NULL,
    [CreatedBy]                 INT      NOT NULL,
    [UpdatedDate]               DATETIME NULL,
    [UpdatedBy]                 INT      NULL,
    CONSTRAINT [PK_ClientRepresentationAgreement_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



