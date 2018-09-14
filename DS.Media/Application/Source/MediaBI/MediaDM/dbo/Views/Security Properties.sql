
CREATE VIEW [dbo].[Security Properties]
AS
SELECT [PropertyKey] AS [Property Key]
      ,[SecurityUserKey] AS [Security User Key]
  FROM [dbo].[Security_FactProperties]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security Properties] TO [DataServices]
    AS [dbo];

