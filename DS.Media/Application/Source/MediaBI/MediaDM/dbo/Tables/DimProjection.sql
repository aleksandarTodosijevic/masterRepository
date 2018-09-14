CREATE TABLE [dbo].[DimProjection] (
    [ProjectionKey]   BIGINT           NOT NULL,
    [ProjectionNo]    VARCHAR (10)     NOT NULL,
    [ProjectionNoT]   VARCHAR (10)     NOT NULL,
    [ProjectionName]  VARCHAR (30)     NULL,
    [ProjectionNameT] VARCHAR (30)     NULL,
    [SubjectCategory] VARCHAR (50)     NOT NULL,
    [HashKey]         VARBINARY (8000) NOT NULL,
    [DeletedOn]       DATETIME         NULL,
    CONSTRAINT [PK_DimProjection] PRIMARY KEY CLUSTERED ([ProjectionKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimProjection] TO [DataServices]
    AS [dbo];

