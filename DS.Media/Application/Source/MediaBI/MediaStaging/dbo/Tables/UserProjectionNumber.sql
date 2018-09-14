CREATE TABLE [dbo].[UserProjectionNumber] (
    [Id]                         INT          NOT NULL,
    [UserId]                     INT          NOT NULL,
    [ProjectionNo]               VARCHAR (10) NOT NULL,
    [UserProjectionNumberRoleId] INT          NOT NULL,
    [StatusId]                   INT          NOT NULL,
    [CreatedDate]                DATETIME     NOT NULL,
    [CreatedBy]                  INT          NOT NULL,
    [UpdatedDate]                DATETIME     NULL,
    [UpdatedBy]                  INT          NULL,
    CONSTRAINT [PK_UserProjectionNumber_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



