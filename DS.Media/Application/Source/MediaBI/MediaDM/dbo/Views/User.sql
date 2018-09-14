



CREATE View [dbo].[User]
AS
SELECT [UserKey] AS [User Key]
      ,[FirstName] AS [First Name]
      ,[LastName] AS [Last Name]
      ,[FullName] AS [Full Name]
      ,[LoginId] AS [Login Id] 
      ,[SystemRole] AS [System Role]
      ,[Locked]
      ,[Status]
	  ,[LastLoginDate] AS [Last Login Date]
	  ,[Email] AS [User Email]
	  ,[PreferencesJson] AS [Preferences Json]
  FROM [dbo].[DimUser]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User] TO [DataServices]
    AS [dbo];

