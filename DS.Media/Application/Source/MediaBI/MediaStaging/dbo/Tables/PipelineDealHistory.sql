CREATE TABLE [dbo].[PipelineDealHistory] (
    [Id]                   INT            NOT NULL,
    [PipelineDealId]       INT            NOT NULL,
    [SalesProgress]        NUMERIC (9, 2) NOT NULL,
    [Info]                 VARCHAR (MAX)  NULL,
    [TerritorySelectionId] INT            NULL,
    [Comment]              VARCHAR (MAX)  NULL,
    [StatusId]             INT            NOT NULL,
    [CreatedDate]          DATETIME       NOT NULL,
    [CreatedBy]            INT            NOT NULL,
    [UpdatedDate]          DATETIME       NULL,
    [UpdatedBy]            INT            NULL,
    [Exclusive]            BIT            NULL,
    [ExclusiveId]          INT            NULL
);







