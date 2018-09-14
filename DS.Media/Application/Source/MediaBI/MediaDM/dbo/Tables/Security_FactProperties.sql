CREATE TABLE [dbo].[Security_FactProperties] (
    [PropertyKey]            BIGINT NOT NULL,
    [SecurityUserKey]        BIGINT NOT NULL,
    [SourceProductId]        INT    NULL,
    [SourceAreaOfBusinessId] INT    NULL,
    CONSTRAINT [FK_Security_FactProperties_Security_DimUser] FOREIGN KEY ([SecurityUserKey]) REFERENCES [dbo].[Security_DimUser] ([SecurityUserKey])
);







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security_FactProperties] TO [DataServices]
    AS [dbo];

