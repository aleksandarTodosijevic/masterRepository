CREATE TABLE [dbo].[Security_FactProjections] (
    [ProjectionKey]      BIGINT       NOT NULL,
    [SecurityUserKey]    BIGINT       NOT NULL,
    [SourceProjectionNo] VARCHAR (10) NOT NULL,
    CONSTRAINT [FK_Security_FactProjection_Security_DimUser] FOREIGN KEY ([SecurityUserKey]) REFERENCES [dbo].[Security_DimUser] ([SecurityUserKey])
);






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security_FactProjections] TO [DataServices]
    AS [dbo];

