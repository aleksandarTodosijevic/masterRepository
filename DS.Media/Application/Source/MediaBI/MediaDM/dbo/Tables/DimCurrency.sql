CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey]         BIGINT           NOT NULL,
    [SourceCurrencyId]    INT              NOT NULL,
    [CurrencyCode]        CHAR (3)         NOT NULL,
    [CurrencyDescription] VARCHAR (50)     NOT NULL,
    [HashKey]             VARBINARY (8000) NOT NULL,
    [DeletedOn]           DATETIME         NULL,
    CONSTRAINT [PK_DimCurrency] PRIMARY KEY CLUSTERED ([CurrencyKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimCurrency] TO [DataServices]
    AS [dbo];

