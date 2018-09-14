CREATE TABLE [dbo].[User] (
    [Id]                INT              NOT NULL,
    [Firstname]         VARCHAR (50)     NOT NULL,
    [Lastname]          VARCHAR (50)     NOT NULL,
    [LoginId]           VARCHAR (20)     NULL,
    [PasswordHash]      VARCHAR (50)     NULL,
    [PasswordKey]       VARCHAR (10)     NULL,
    [EmployeeNo]        VARCHAR (50)     NULL,
    [Company]           VARCHAR (50)     NULL,
    [SystemRoleId]      INT              NOT NULL,
    [Phone]             VARCHAR (30)     NULL,
    [Mobile]            VARCHAR (30)     NULL,
    [Email]             VARCHAR (80)     NULL,
    [Fax]               VARCHAR (30)     NULL,
    [DefaultCcyId]      INT              NULL,
    [Locked]            BIT              NULL,
    [ReceiveEmails]     BIT              NULL,
    [PreferencesBitSum] INT              NULL,
    [StatusId]          INT              NULL,
    [CreatedDate]       DATETIME         NULL,
    [CreatedBy]         INT              NULL,
    [UpdatedDate]       DATETIME         NULL,
    [UpdatedBy]         INT              NULL,
    [PreferencesJson]   NVARCHAR (MAX)   NULL,
    [UserPrincipalName] VARCHAR (50)     NULL,
    [ActiveDirectoryId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_User_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);









