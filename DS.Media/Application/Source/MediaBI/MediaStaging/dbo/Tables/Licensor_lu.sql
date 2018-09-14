CREATE TABLE [dbo].[Licensor_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (50) NULL,
    [Reference]   CHAR (1)     NULL,
    [StatusId]    INT          NULL,
    [CreatedDate] DATETIME     NULL,
    [CreatedBy]   INT          NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_Licensor_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);



