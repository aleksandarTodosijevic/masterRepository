CREATE TABLE [dbo].[SubjectCategory_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_SubjectCategory_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



