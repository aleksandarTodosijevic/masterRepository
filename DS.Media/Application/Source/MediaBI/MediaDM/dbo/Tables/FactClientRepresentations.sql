CREATE TABLE [dbo].[FactClientRepresentations] (
    [PropertyKey]      BIGINT           NOT NULL,
    [ClientKey]        BIGINT           NOT NULL,
    [UltimateOwnerKey] BIGINT           NOT NULL,
    [IsUltimateOwner]  BIT              NOT NULL,
    [HashKey]          VARBINARY (8000) NULL,
    [DeletedOn]        DATETIME         NULL,
    CONSTRAINT [FK_FactClientRepresentations_DimClient] FOREIGN KEY ([ClientKey]) REFERENCES [dbo].[DimClient] ([ClientKey]),
    CONSTRAINT [FK_FactClientRepresentations_DimProperty] FOREIGN KEY ([PropertyKey]) REFERENCES [dbo].[DimProperty] ([PropertyKey])
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactClientRepresentations] TO [DataServices]
    AS [dbo];

