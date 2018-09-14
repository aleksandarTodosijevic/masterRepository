CREATE TABLE [dbo].[OrderDetailDelivery] (
    [Id]                 INT            NOT NULL,
    [OrderHeaderId]      INT            NULL,
    [OrderDetailId]      INT            NULL,
    [ProductId]          INT            NULL,
    [ProductTypeId]      INT            NULL,
    [ProductCategoryId]  INT            NULL,
    [VersionId]          INT            NULL,
    [DeliveryTypeId]     INT            NULL,
    [IsOnHold]           BIT            NULL,
    [LanguageId]         INT            NULL,
    [VideoStandardId]    INT            NULL,
    [TapeFormatId]       INT            NULL,
    [AspectRatioId]      INT            NULL,
    [AudioFormatId]      INT            NULL,
    [FeedCoordinationId] INT            NULL,
    [ShipDate]           DATETIME       NULL,
    [ShippingInfo]       VARCHAR (255)  NULL,
    [Comments]           VARCHAR (2048) NULL,
    [ShippedDate]        DATETIME       NULL,
    [AWBNumber]          VARCHAR (20)   NULL,
    [NumberOfTapes]      INT            NULL,
    [EmailedDate]        DATETIME       NULL,
    [CustomerContactId]  INT            NULL,
    [CustomerAddressId]  INT            NULL,
    [StatusId]           INT            NOT NULL,
    [CreatedDate]        DATETIME       NOT NULL,
    [CreatedBy]          INT            NOT NULL,
    [UpdatedDate]        DATETIME       NULL,
    [UpdatedBy]          INT            NULL,
    CONSTRAINT [PK_OrderDetailDelivery_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);





