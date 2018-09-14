CREATE TABLE [dbo].[Security_FactSalesAreas] (
    [SalesAreaKey]    BIGINT NOT NULL,
    [SecurityUserKey] BIGINT NOT NULL,
    CONSTRAINT [FK_Security_FactSalesAreas_Security_DimUser] FOREIGN KEY ([SecurityUserKey]) REFERENCES [dbo].[Security_DimUser] ([SecurityUserKey])
);







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security_FactSalesAreas] TO [DataServices]
    AS [dbo];

