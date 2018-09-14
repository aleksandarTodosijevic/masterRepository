/****** Script for SelectTopNRows command from SSMS  ******/
Create View [dbo].[User Roles]
AS
SELECT [UserKey] AS [User Key]
      ,[RoleKey] AS [Role Key]
      ,[CountOfRoles] AS [Count Of Roles]
  FROM [dbo].[FactUserRoles]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Roles] TO [DataServices]
    AS [dbo];

