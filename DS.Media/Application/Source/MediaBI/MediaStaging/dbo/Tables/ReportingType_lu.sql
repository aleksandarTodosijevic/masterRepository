CREATE TABLE [dbo].[ReportingType_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (80) NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_ReportingType_lu_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95, PAD_INDEX = ON)
);

