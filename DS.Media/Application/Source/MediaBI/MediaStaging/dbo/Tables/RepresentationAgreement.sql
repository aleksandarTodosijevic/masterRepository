CREATE TABLE [dbo].[RepresentationAgreement] (
    [Id]                INT          NOT NULL,
    [AgreementNo]       VARCHAR (20) NULL,
    [StartDate]         DATETIME     NULL,
    [EndDate]           DATETIME     NULL,
    [ExecResponsibleId] INT          NULL,
    [StatusId]          INT          NOT NULL,
    [CreatedDate]       DATETIME     NOT NULL,
    [CreatedBy]         INT          NOT NULL,
    [UpdatedDate]       DATETIME     NULL,
    [UpdatedBy]         INT          NULL,
    CONSTRAINT [PK_RepresentationAgreement_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



