CREATE TABLE [dbo].[IssueSiteLegalOnlineContact] (
    [Id]          INT      NOT NULL,
    [IssueSiteId] INT      NOT NULL,
    [UserId]      INT      NOT NULL,
    [StatusId]    INT      NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [CreatedBy]   INT      NOT NULL,
    [UpdatedDate] DATETIME NULL,
    [UpdatedBy]   INT      NULL
);





