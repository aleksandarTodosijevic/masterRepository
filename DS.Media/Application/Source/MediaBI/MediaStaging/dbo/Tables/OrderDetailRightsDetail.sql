CREATE TABLE [dbo].[OrderDetailRightsDetail] (
    [Id]                    INT           NOT NULL,
    [OrderDetailId]         INT           NOT NULL,
    [ParentId]              INT           NULL,
    [DesignatedRightId]     INT           NOT NULL,
    [LicenseStartDate]      DATETIME      NOT NULL,
    [LicenseEndDate]        DATETIME      NOT NULL,
    [TVHoldback]            BIT           NOT NULL,
    [TVHoldbackComment]     VARCHAR (400) NULL,
    [NumberOfTransmissions] INT           NULL,
    [Exclusive]             BIT           NOT NULL,
    [RightsSelectionId]     INT           NOT NULL,
    [TerritorySelectionId]  INT           NOT NULL,
    [LanguageSelectionId]   INT           NOT NULL,
    [IsClashing]            BIT           NOT NULL,
    [StatusId]              INT           NOT NULL,
    [CreatedDate]           DATETIME      NOT NULL,
    [CreatedBy]             INT           NOT NULL,
    [UpdatedDate]           DATETIME      NULL,
    [UpdatedBy]             INT           NULL,
    CONSTRAINT [PK_OrderDetailRightsDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);



