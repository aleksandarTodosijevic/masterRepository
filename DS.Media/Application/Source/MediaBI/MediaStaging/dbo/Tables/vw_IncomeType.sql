CREATE TABLE [dbo].[vw_IncomeType] (
    [FeeId]                 INT          NOT NULL,
    [Description]           VARCHAR (50) NOT NULL,
    [SAPMaterialNumber]     INT          NOT NULL,
    [SAPAccountGroup]       CHAR (4)     NOT NULL,
    [SalesCategoryId]       INT          NOT NULL,
    [FeeTypeId]             INT          NOT NULL,
    [FeeType]               VARCHAR (50) NOT NULL,
    [IncomeTypeId]          INT          NOT NULL,
    [MasterIncomeType]      VARCHAR (50) NOT NULL,
    [MasterIncomeTypeId]    INT          NOT NULL,
    [MasterSalesCategoryId] INT          NOT NULL,
    [IncomeTypeStatusId]    INT          NOT NULL
);



