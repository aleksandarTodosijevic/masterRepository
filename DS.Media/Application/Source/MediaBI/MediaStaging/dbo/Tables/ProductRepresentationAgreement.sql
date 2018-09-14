CREATE TABLE [dbo].[ProductRepresentationAgreement] (
    [Id]                        INT      NOT NULL,
    [ProductId]                 INT      NULL,
    [RepresentationAgreementId] INT      NULL,
    [StatusId]                  INT      NOT NULL,
    [CreatedDate]               DATETIME NOT NULL,
    [CreatedBy]                 INT      NOT NULL,
    [UpdatedDate]               DATETIME NULL,
    [UpdatedBy]                 INT      NULL,
    CONSTRAINT [PK_ProductRepresentationAgreement_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



