CREATE TABLE [dbo].[BusinessType_lu] (
    [Id]             INT          NOT NULL,
    [Description]    VARCHAR (50) NOT NULL,
    [ConversionCode] VARCHAR (3)  NULL,
    [StatusId]       INT          NOT NULL,
    [CreatedDate]    DATETIME     NOT NULL,
    [CreatedBy]      INT          NOT NULL,
    [UpdatedDate]    DATETIME     NULL,
    [UpdatedBy]      INT          NULL,
    CONSTRAINT [PK_BusinessType_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



