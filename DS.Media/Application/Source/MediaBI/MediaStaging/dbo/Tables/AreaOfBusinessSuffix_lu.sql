CREATE TABLE [dbo].[AreaOfBusinessSuffix_lu] (
    [Id]                     CHAR (2)     NOT NULL,
    [ProjectionCategoryCode] CHAR (2)     NOT NULL,
    [Description]            VARCHAR (50) NOT NULL,
    [AreaOfBusinessId]       INT          NOT NULL,
    [StatusId]               INT          NOT NULL,
    [CreatedDate]            DATETIME     NOT NULL,
    [CreatedBy]              INT          NOT NULL,
    [UpdatedDate]            DATETIME     NULL,
    [UpdatedBy]              INT          NULL,
    CONSTRAINT [PK_AreaOfBusinessSuffix_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



