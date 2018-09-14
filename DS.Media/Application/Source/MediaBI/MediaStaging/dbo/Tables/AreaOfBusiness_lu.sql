CREATE TABLE [dbo].[AreaOfBusiness_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_AreaOfBusiness_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



