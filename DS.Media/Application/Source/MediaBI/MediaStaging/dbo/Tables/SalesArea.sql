CREATE TABLE [dbo].[SalesArea] (
    [Id]                INT          NOT NULL,
    [SalesRegionId]     INT          NOT NULL,
    [AreaNumber]        VARCHAR (4)  NOT NULL,
    [Description]       VARCHAR (50) NOT NULL,
    [ExecResponsibleId] INT          NULL,
    [StatusId]          INT          NOT NULL,
    [CreatedDate]       DATETIME     NOT NULL,
    [CreatedBy]         INT          NOT NULL,
    [UpdatedDate]       DATETIME     NULL,
    [UpdatedBy]         INT          NULL,
    CONSTRAINT [PK_SalesArea] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



