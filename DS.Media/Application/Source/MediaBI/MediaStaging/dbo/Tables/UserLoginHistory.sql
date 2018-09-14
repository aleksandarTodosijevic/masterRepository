CREATE TABLE [dbo].[UserLoginHistory] (
    [Id]          INT          NOT NULL,
    [UserId]      INT          NULL,
    [IPAddress]   VARCHAR (50) NULL,
    [LoginId]     VARCHAR (50) NULL,
    [ServerName]  VARCHAR (50) NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_UserLoginHistory_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



