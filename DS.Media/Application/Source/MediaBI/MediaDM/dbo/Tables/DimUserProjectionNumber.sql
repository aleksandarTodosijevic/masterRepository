CREATE TABLE [dbo].[DimUserProjectionNumber] (
    [UserProjectionNumberKey] BIGINT           NOT NULL,
    [ProjectionNumberNo]      VARCHAR (10)     NOT NULL,
    [ProjectionNumber]        VARCHAR (30)     NOT NULL,
    [HashKey]                 VARBINARY (8000) NOT NULL,
    [DeletedOn]               DATETIME         NULL,
    CONSTRAINT [PK_DimUserProjectionNumber] PRIMARY KEY CLUSTERED ([UserProjectionNumberKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimUserProjectionNumber] TO [DataServices]
    AS [dbo];

