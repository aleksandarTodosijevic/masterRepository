CREATE TABLE [dbo].[DimPipelineDeal] (
    [PipelineDealKey]            BIGINT         NOT NULL,
    [PipelineDealId]             INT            NULL,
    [SalesProgress]              NUMERIC (9, 2) NOT NULL,
    [Reason]                     VARCHAR (4000) NULL,
    [PipelineDealStatus]         VARCHAR (7)    NOT NULL,
    [CreatedDate]                DATE           NULL,
    [UpdatedDate]                DATE           NULL,
    [PipelineTerritorySelection] VARCHAR (2048) NULL,
    [CreatedBy]                  VARCHAR (100)  NULL,
    [IsExclusive]                CHAR(3) NULL, 
    [HashKey] VARBINARY(8000) NOT NULL, 
    [DeletedOn] DATETIME NULL, 
    CONSTRAINT [PK_DimPipelineDeal] PRIMARY KEY CLUSTERED ([PipelineDealKey] ASC)
);






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimPipelineDeal] TO [DataServices]
    AS [dbo];

