CREATE TABLE [dbo].[Security_DimUser] (
    [SecurityUserKey] BIGINT        NOT NULL,
    [SourceUserId]    INT           NOT NULL,
    [FullName]        VARCHAR (100) NOT NULL,
    [DomainName]      VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_Security_DimUser] PRIMARY KEY CLUSTERED ([SecurityUserKey] ASC)
);






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security_DimUser] TO [DataServices]
    AS [dbo];

