CREATE TABLE [dbo].[MDS_Commission] (
    [ID]                   INT              NOT NULL,
    [MUID]                 UNIQUEIDENTIFIER NOT NULL,
    [VersionName]          NVARCHAR (50)    NOT NULL,
    [VersionNumber]        INT              NOT NULL,
    [Version_ID]           INT              NOT NULL,
    [VersionFlag]          NVARCHAR (50)    NULL,
    [Name]                 NVARCHAR (250)   NULL,
    [Code]                 NVARCHAR (250)   NOT NULL,
    [ChangeTrackingMask]   INT              NOT NULL,
    [Abbreviation]         NVARCHAR (100)   NULL,
    [Sales Category_Code]  NVARCHAR (250)   NULL,
    [Sales Category_Name]  NVARCHAR (250)   NULL,
    [Sales Category_ID]    INT              NULL,
    [Commission]           DECIMAL (38, 2)  NULL,
    [Comment]              NVARCHAR (250)   NULL,
    [EnterDateTime]        DATETIME2 (3)    NOT NULL,
    [EnterUserName]        NVARCHAR (100)   NULL,
    [EnterVersionNumber]   INT              NOT NULL,
    [LastChgDateTime]      DATETIME2 (3)    NOT NULL,
    [LastChgUserName]      NVARCHAR (100)   NULL,
    [LastChgVersionNumber] INT              NOT NULL,
    [ValidationStatus]     NVARCHAR (250)   NULL
);



