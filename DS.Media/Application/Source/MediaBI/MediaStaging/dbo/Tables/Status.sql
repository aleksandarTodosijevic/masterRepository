CREATE TABLE [dbo].[Status] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (20) NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_Status_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



