CREATE TABLE [dbo].[Version] (
    [Id]                 INT          NOT NULL,
    [ProductId]          INT          NOT NULL,
    [Description]        VARCHAR (70) NOT NULL,
    [NetworkAudio]       BIT          NULL,
    [InternationalTrack] BIT          NULL,
    [FeedCoordinationId] INT          NULL,
    [AvailableDate]      DATETIME     NULL,
    [VersionType]        INT          NOT NULL,
    [StatusId]           INT          NOT NULL,
    [CreatedDate]        DATETIME     NOT NULL,
    [CreatedBy]          INT          NOT NULL,
    [UpdatedDate]        DATETIME     NULL,
    [UpdatedBy]          INT          NULL,
    CONSTRAINT [PK_Version_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



