CREATE TABLE [dbo].[UserRole] (
    [Id]          INT      NOT NULL,
    [UserId]      INT      NOT NULL,
    [RoleId]      INT      NOT NULL,
    [StatusId]    INT      NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [CreatedBy]   INT      NOT NULL,
    [UpdatedDate] DATETIME NULL,
    [UpdatedBy]   INT      NULL,
    CONSTRAINT [PK_UserRole_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);





