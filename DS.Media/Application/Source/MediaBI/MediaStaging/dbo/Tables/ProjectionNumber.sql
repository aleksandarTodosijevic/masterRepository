CREATE TABLE [dbo].[ProjectionNumber] (
    [Id]          VARCHAR (10) NOT NULL,
    [Description] VARCHAR (30) NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_ProjectionNumber] PRIMARY KEY CLUSTERED ([Id] ASC)
);



