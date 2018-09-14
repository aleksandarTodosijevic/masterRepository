CREATE TABLE [dbo].[PipelineDeal] (
    [Id]                   INT            NOT NULL,
    [SalesProgress]        NUMERIC (9, 2) NOT NULL,
    [Info]                 VARCHAR (MAX)  NULL,
    [Exclusive]            BIT            NULL,
    [ExclusiveId]          INT            NULL,
    [TerritorySelectionId] INT            NULL,
    [StatusId]             INT            NOT NULL,
    [CreatedDate]          DATETIME       NOT NULL,
    [CreatedBy]            INT            NOT NULL,
    [UpdatedDate]          DATETIME       NULL,
    [UpdatedBy]            INT            NULL
);







