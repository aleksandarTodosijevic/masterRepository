
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[Security Projections]
AS
SELECT [ProjectionKey] AS [Projection Key]
      ,[SecurityUserKey] AS [Security User Key]
  FROM [Security_FactProjections]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Security Projections] TO [DataServices]
    AS [dbo];

