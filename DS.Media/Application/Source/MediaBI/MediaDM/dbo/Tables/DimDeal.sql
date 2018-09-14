CREATE TABLE [dbo].[DimDeal] (
    [DealKey]            BIGINT           NOT NULL,
    [DealNo]             INT              NOT NULL,
    [CustomerId]         INT              NOT NULL,
    [SalesAreaId]        INT              NOT NULL,
    [DealStatus]         VARCHAR (30)     NOT NULL,
    [SalesCategory]      VARCHAR (50)     NOT NULL,
    [FirstProcessedDate] DATETIME         NULL,
    [LastProcessedDate]  DATETIME         NULL,
    [HashKey]            VARBINARY (8000) NOT NULL,
    [DeletedOn]          DATETIME         NULL,
    CONSTRAINT [PK_DimDeal] PRIMARY KEY CLUSTERED ([DealKey] ASC)
);









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimDeal] TO [DataServices]
    AS [dbo];

