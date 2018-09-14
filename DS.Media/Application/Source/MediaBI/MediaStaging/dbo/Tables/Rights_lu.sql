CREATE TABLE [dbo].[Rights_lu] (
    [Id]                  INT            NOT NULL,
    [FullPathDescription] VARCHAR (150)  NOT NULL,
    [FullDescription]     VARCHAR (150)  NOT NULL,
    [Description]         VARCHAR (150)  NOT NULL,
    [IsRight]             BIT            NOT NULL,
    [Definition]          VARCHAR (1024) NULL,
    [StatusId]            INT            NOT NULL,
    [CreatedDate]         DATETIME       NOT NULL,
    [CreatedBy]           INT            NOT NULL,
    [UpdatedDate]         DATETIME       NULL,
    [UpdatedBy]           INT            NULL,
    CONSTRAINT [PK_Rights_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



