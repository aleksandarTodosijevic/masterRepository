CREATE VIEW [dbo].[Security Sales Areas]
AS
SELECT [SalesAreaKey] AS [Sales Area Key]
      ,[SecurityUserKey] AS [Security User Key]
  FROM [dbo].[Security_FactSalesAreas]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security Sales Areas] TO [DataServices]
    AS [dbo];

