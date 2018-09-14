CREATE TABLE [dbo].[LanguageSelection] (
    [LanguageSelectionId] INT      NOT NULL,
    [LanguageId]          INT      NOT NULL,
    [StatusId]            INT      NOT NULL,
    [CreatedDate]         DATETIME NOT NULL,
    [CreatedBy]           INT      NOT NULL,
    [UpdatedDate]         DATETIME NULL,
    [UpdatedBy]           INT      NULL,
    CONSTRAINT [PK_LanguageSelection] PRIMARY KEY CLUSTERED ([LanguageSelectionId] ASC, [LanguageId] ASC)
);



