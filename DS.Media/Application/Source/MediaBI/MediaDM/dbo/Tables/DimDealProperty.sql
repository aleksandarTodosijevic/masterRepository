CREATE TABLE [dbo].[DimDealProperty] (
    [DealPropertyKey]			BIGINT           NOT NULL,
    [SourceOrderDetailID]		INT              NOT NULL,
    [ClientName]				VARCHAR (160)    NOT NULL,
    [InvoicingCompany]			VARCHAR (80)     NOT NULL,
    [CompanyCode]				CHAR (3)         NOT NULL,
	[EntertainmentShippedDate]	DATE			 NULL,
	[RecognitionDate]			DATE			 NULL,
    [HashKey]					VARBINARY (8000) NOT NULL,
    [DeletedOn]					DATETIME         NULL,
    CONSTRAINT [PK_DimDealProperty] PRIMARY KEY CLUSTERED ([DealPropertyKey] ASC)
);










GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimDealProperty] TO [DataServices]
    AS [dbo];

