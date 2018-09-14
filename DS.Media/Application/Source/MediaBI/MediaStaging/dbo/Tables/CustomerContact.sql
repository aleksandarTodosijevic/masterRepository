CREATE TABLE [dbo].[CustomerContact] (
    [Id]                     INT          NOT NULL,
    [CustomerId]             INT          NOT NULL,
    [ContactName]            VARCHAR (35) NOT NULL,
    [Phone]                  VARCHAR (20) NULL,
    [Fax]                    VARCHAR (31) NULL,
    [Email]                  VARCHAR (80) NULL,
    [SapNotificationByEmail] BIT          NOT NULL,
    [CategoryBitSum]         INT          NULL,
    [StatusId]               INT          NOT NULL,
    [CreatedDate]            DATETIME     NOT NULL,
    [CreatedBy]              INT          NOT NULL,
    [UpdatedDate]            DATETIME     NULL,
    [UpdatedBy]              INT          NULL,
    CONSTRAINT [PK_CustomerContact] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE INDEX [IX_CustomerContact_CustomerId] ON [dbo].[CustomerContact] ([CustomerId]);