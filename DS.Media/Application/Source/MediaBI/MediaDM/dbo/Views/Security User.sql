
CREATE VIEW [dbo].[Security User]
AS
SELECT [SecurityUserKey] AS [Security User Key]
      ,[DomainName]  AS [Domain Name]
  FROM [dbo].[Security_DimUser]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security User] TO [DataServices]
    AS [dbo];

