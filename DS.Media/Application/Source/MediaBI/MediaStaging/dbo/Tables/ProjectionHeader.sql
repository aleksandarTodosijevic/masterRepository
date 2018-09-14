CREATE TABLE [dbo].[ProjectionHeader] (
    [Id]                  INT             NOT NULL,
    [ProjectionYear]      CHAR (4)        NOT NULL,
    [SalesAreaId]         INT             NOT NULL,
    [IncomeTypeId]        INT             NOT NULL,
    [FeeTypeId]           INT             NOT NULL,
    [SalesCategoryId]     INT             NOT NULL,
    [LockedById]          INT             NULL,
    [TotalAnticipated]    DECIMAL (16, 2) NOT NULL,
    [TotalActuals]        DECIMAL (16, 2) NOT NULL,
    [LastCalculationDate] DATETIME        NOT NULL,
    [StatusId]            INT             NOT NULL,
    [CreatedDate]         DATETIME        NOT NULL,
    [CreatedBy]           INT             NOT NULL,
    [UpdatedDate]         DATETIME        NULL,
    [UpdatedBy]           INT             NULL,
    CONSTRAINT [PK_ProjectionHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);



