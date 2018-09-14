CREATE TABLE [dbo].[UserBillingCompany] (
    [Id]               INT      NOT NULL,
    [UserId]           INT      NOT NULL,
    [BillingCompanyId] INT      NOT NULL,
    [StatusId]         INT      NOT NULL,
    [CreatedDate]      DATETIME NOT NULL,
    [CreatedBy]        INT      NOT NULL,
    [UpdatedDate]      DATETIME NULL,
    [UpdatedBy]        INT      NULL,
    CONSTRAINT [PK_UserBillingCompany_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);





