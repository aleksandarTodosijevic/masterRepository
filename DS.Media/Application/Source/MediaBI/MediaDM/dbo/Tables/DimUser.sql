CREATE TABLE [dbo].[DimUser] (
    [UserKey]         BIGINT           NOT NULL,
    [SourceUserId]    INT              NOT NULL,
    [FirstName]       VARCHAR (50)     NOT NULL,
    [LastName]        VARCHAR (50)     NOT NULL,
    [FullName]        VARCHAR (100)    NOT NULL,
    [LoginId]         VARCHAR (20)     DEFAULT ('N/A') NOT NULL,
    [SystemRole]      VARCHAR (50)     DEFAULT ('N/A') NOT NULL,
    [Locked]          CHAR (3)         DEFAULT ('N/A') NOT NULL,
    [Status]          VARCHAR (20)     DEFAULT ('N/A') NOT NULL,
    [LastLoginDate]   DATE             CONSTRAINT [DF_DimUser_LastLoginDate] DEFAULT ('1900-01-01') NULL,
    [Email]           VARCHAR (80)     NOT NULL,
    [PreferencesJson] NVARCHAR (MAX)   DEFAULT ('N/A') NOT NULL,
    [HashKey]         VARBINARY (8000) NOT NULL,
    [DeletedOn]       DATETIME         NULL,
    CONSTRAINT [PK_DimUser] PRIMARY KEY CLUSTERED ([UserKey] ASC)
);














GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimUser] TO [DataServices]
    AS [dbo];

