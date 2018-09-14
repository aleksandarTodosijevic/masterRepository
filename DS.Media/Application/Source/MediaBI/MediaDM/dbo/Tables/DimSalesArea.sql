CREATE TABLE [dbo].[DimSalesArea] (
    [SalesAreaKey]      BIGINT           NOT NULL,
    [SourceSalesAreaId] INT              NOT NULL,
    [SalesRegion]       VARCHAR (50)     NOT NULL,
    [SalesArea]         VARCHAR (50)     NOT NULL,
    [AreaNumber]        VARCHAR (4)      NOT NULL,
    [ExecResponsible]   VARCHAR (101)    NULL,
    [SalesAreaStatus]   VARCHAR (20)     NULL,
	[EntertainmentSalesExec] NVARCHAR (100) NULL,
    [HashKey]           VARBINARY (8000) NOT NULL,
    [DeletedOn]         DATETIME         NULL,
    CONSTRAINT [PK_DimSalesArea] PRIMARY KEY CLUSTERED ([SalesAreaKey] ASC)
);






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimSalesArea] TO [DataServices]
    AS [dbo];

