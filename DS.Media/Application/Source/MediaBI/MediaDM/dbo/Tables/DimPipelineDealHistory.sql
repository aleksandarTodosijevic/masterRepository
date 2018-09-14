CREATE TABLE [dbo].[DimPipelineDealHistory] (
    [PipelineDealHistoryKey]           BIGINT           NOT NULL,
    [PipelineDealId]                   INT              NULL,
    [SalesProgress]                    NUMERIC (9, 2)   NOT NULL,
    [Reason]                           VARCHAR (4000)   NULL,
    [PipelineDealStatus]               VARCHAR (7)      NOT NULL,
    [CreatedDate]                      DATE             NULL,
    [UpdatedDate]                      DATE             NULL,
    [PipelineTerritorySelection]       VARCHAR (2048)   NULL,
    [DescendingOrderOfChanges]         INT              NULL,
    [CreatedBy]                        VARCHAR (100)    NULL,
    [IsExclusive]                      CHAR (3)         NULL,
    [HashKey]                          VARBINARY (8000) NOT NULL,
    [DeletedOn]                        DATETIME         NULL,
    [SalesProgressChange]              CHAR (3)         NULL,
    [ReasonChange]                     CHAR (3)         NULL,
    [PipelineDealStatusChange]         CHAR (3)         NULL,
    [PipelineTerritorySelectionChange] CHAR (3)         NULL,
    [IsExclusiveChange]                CHAR (3)         NULL,
    CONSTRAINT [PK_DimPipelineDealHistory] PRIMARY KEY CLUSTERED ([PipelineDealHistoryKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimPipelineDealHistory] TO [DataServices]
    AS [dbo];

