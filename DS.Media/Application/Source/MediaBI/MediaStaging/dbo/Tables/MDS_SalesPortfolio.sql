CREATE TABLE [dbo].[MDS_SalesPortfolio] (
    [ID]                 INT             NOT NULL,
    [Name]               NVARCHAR (250)  NULL,
    [Code]               NVARCHAR (250)  NOT NULL,
    [SubjectCategory_ID] INT             NULL,
    [T_Number]           NVARCHAR (10)   NULL,
    [PropertyName]       NVARCHAR (100)  NULL,
    [Year_Code]          NVARCHAR (250)  NULL,
    [Year_Name]          NVARCHAR (250)  NULL,
    [Year_ID]            INT             NULL,
    [200A_PreviousYear]  DECIMAL (38, 2) NULL,
    [BudgetTotal]        DECIMAL (38, 2) NULL,
    [SaleType_Code]      NVARCHAR (250)  NULL,
    [SaleType_Name]      NVARCHAR (250)  NULL,
    [SaleType_ID]        INT             NULL,
    [Forecast]           DECIMAL (38, 2) NULL,
    [DateOfExpiry]       DATETIME2 (3)   NULL,
    [EffectiveDate]      NVARCHAR (10)    NULL,
    [EnterDateTime]      DATETIME2 (3)   NOT NULL,
    [EnterUserName]      NVARCHAR (100)  NULL,
    [EnterVersionNumber] INT             NULL
);



