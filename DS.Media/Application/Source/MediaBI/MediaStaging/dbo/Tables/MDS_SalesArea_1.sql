CREATE TABLE [dbo].[MDS_SalesArea] (
    [ID]                     INT              NOT NULL,
    [MUID]                   UNIQUEIDENTIFIER NOT NULL,
    [VersionName]            NVARCHAR (50)    NOT NULL,
    [VersionNumber]          INT              NOT NULL,
    [Version_ID]             INT              NOT NULL,
    [VersionFlag]            NVARCHAR (50)    NULL,
    [Name]                   NVARCHAR (250)   NULL,
    [Code]                   NVARCHAR (250)   NOT NULL,
    [ChangeTrackingMask]     INT              NOT NULL,
    [EntertainmentSalesExec] NVARCHAR (100)   NULL,
    [EnterDateTime]          DATETIME2 (3)    NOT NULL,
    [EnterUserName]          NVARCHAR (100)   NULL,
    [EnterVersionNumber]     INT              NULL,
    [LastChgDateTime]        DATETIME2 (3)    NOT NULL,
    [LastChgUserName]        NVARCHAR (100)   NULL,
    [LastChgVersionNumber]   INT              NULL,
    [ValidationStatus]       NVARCHAR (250)   NULL
);