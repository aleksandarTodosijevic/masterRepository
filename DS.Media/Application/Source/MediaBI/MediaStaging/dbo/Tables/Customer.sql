CREATE TABLE [dbo].[Customer] (
    [Id]                         INT           NOT NULL,
    [CustomerTypeId]             INT           NULL,
    [BusinessTypeId]             INT           NULL,
    [IsHoldingCompany]           BIT           NOT NULL,
    [IsIntercompanyCustomer]     BIT           NOT NULL,
    [CustomerNo]                 INT           NULL,
    [CustomerName]               VARCHAR (35)  NOT NULL,
    [CustomerName2]              VARCHAR (35)  NULL,
    [ShortName]                  VARCHAR (20)  NOT NULL,
    [CustomerFullName]           VARCHAR (80)  NOT NULL,
    [ParentId]                   INT           NULL,
    [CurrencyId]                 INT           NOT NULL,
    [TapeFormatId]               INT           NULL,
    [AspectRatioId]              INT           NULL,
    [SalesTaxNumber]             VARCHAR (30)  NULL,
    [ShippingInfo]               VARCHAR (255) NULL,
    [EBUMember]                  BIT           NULL,
    [InvoiceCategoryId]          INT           NULL,
    [ProjectionTerritoryId]      INT           NOT NULL,
    [RightsTerritorySelectionId] INT           NULL,
    [BlockedDate]                DATETIME      NOT NULL,
    [StatusId]                   INT           NOT NULL,
    [CreatedDate]                DATETIME      NOT NULL,
    [CreatedBy]                  INT           NOT NULL,
    [UpdatedDate]                DATETIME      NULL,
    [UpdatedBy]                  INT           NULL,
    [RightsSelectionId]          INT           NULL,
    [TerritorySelectionId]       INT           NULL,
    [LanguageSelectionId]        INT           NULL,
    [IsExclusive]                BIT           NULL,
    [NumberOfTransmissions]      INT           NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([Id] ASC)
);







