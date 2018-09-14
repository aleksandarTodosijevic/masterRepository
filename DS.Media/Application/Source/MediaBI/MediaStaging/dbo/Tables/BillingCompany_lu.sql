CREATE TABLE [dbo].[BillingCompany_lu] (
    [Id]              INT          NOT NULL,
    [IssueSiteId]     INT          NOT NULL,
    [OfficeId]        INT          NULL,
    [Description]     VARCHAR (80) NOT NULL,
    [SAPCompanyName]  VARCHAR (80) NULL,
    [SAPCompanyCode]  CHAR (3)     NOT NULL,
    [IsSAPInterfaced] BIT          NOT NULL,
    [SystemArea]      INT          NULL,
    [StatusId]        INT          NOT NULL,
    [CreatedDate]     DATETIME     NOT NULL,
    [CreatedBy]       INT          NOT NULL,
    [UpdatedDate]     DATETIME     NULL,
    [UpdatedBy]       INT          NULL,
    CONSTRAINT [PK_BillingCompany_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);







