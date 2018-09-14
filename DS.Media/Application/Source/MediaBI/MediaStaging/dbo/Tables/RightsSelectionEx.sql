﻿CREATE TABLE [dbo].[RightsSelectionEx] (
    [Id]          INT            NOT NULL,
    [HashKey]     INT            NOT NULL,
    [Description] VARCHAR (2048) NOT NULL,
    [StatusId]    INT            NOT NULL,
    [CreatedDate] DATETIME       NOT NULL,
    [CreatedBy]   INT            NOT NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    CONSTRAINT [PK_RightsSelectionEx] PRIMARY KEY CLUSTERED ([Id] ASC)
);



