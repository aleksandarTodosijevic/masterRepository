/****** Script for SelectTopNRows command from SSMS  ******/
Create View [dbo].[Role]
AS
SELECT [RoleKey] AS [Role Key]
      ,[NameOfRole] AS [Name Of Role]
      ,[CommentOfRole] AS [Comment Of Role]
  FROM [dbo].[DimRole]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Role] TO [DataServices]
    AS [dbo];

