CREATE TABLE [dbo].[DesignatedRight] (
    [Id]                   INT      NOT NULL,
    [ProductId]            INT      NOT NULL,
    [RightsSelectionId]    INT      NOT NULL,
    [TerritorySelectionId] INT      NOT NULL,
    [LanguageSelectionId]  INT      NOT NULL,
    [IsExclusive]          BIT      NOT NULL,
    [LicenseStartDate]     DATETIME NOT NULL,
    [LicenseEndDate]       DATETIME NOT NULL,
    [Revalidate]           BIT      NOT NULL,
    [StatusId]             INT      NOT NULL,
    [CreatedDate]          DATETIME NOT NULL,
    [CreatedBy]            INT      NOT NULL,
    [UpdatedDate]          DATETIME NULL,
    [UpdatedBy]            INT      NULL,
    CONSTRAINT [PK_DesignatedRight] PRIMARY KEY CLUSTERED ([Id] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_DesignatedRight]
    ON [dbo].[DesignatedRight]([TerritorySelectionId] ASC);

