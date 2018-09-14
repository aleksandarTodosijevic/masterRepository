CREATE TABLE [dbo].[DimIncomeType] (
    [IncomeTypeKey]      BIGINT           NOT NULL,
    [SourceIncomeTypeId] INT              NOT NULL,
    [SalesCategory]      VARCHAR (50)     NOT NULL,
    [FeeType]            VARCHAR (9)      NULL,
    [FeeDescription]     VARCHAR (50)     NOT NULL,
    [HashKey]            VARBINARY (8000) NOT NULL,
    [DeletedOn]          DATETIME         NULL,
    CONSTRAINT [PK_DimIncomeType] PRIMARY KEY CLUSTERED ([IncomeTypeKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimIncomeType] TO [DataServices]
    AS [dbo];

