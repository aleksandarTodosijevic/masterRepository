CREATE TABLE [dbo].[RightsSelection] (
    [RightsSelectionId] INT      NOT NULL,
    [RightsTreeId]      INT      NOT NULL,
    [RightsId]          INT      NOT NULL,
    [StatusId]          INT      NOT NULL,
    [CreatedDate]       DATETIME NOT NULL,
    [CreatedBy]         INT      NOT NULL,
    [UpdatedDate]       DATETIME NULL,
    [UpdatedBy]         INT      NULL,
    CONSTRAINT [PK_RightsSelection] PRIMARY KEY CLUSTERED ([RightsSelectionId] ASC, [RightsTreeId] ASC)
);



