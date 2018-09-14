CREATE VIEW [dbo].[Deal Updated By]
AS
	
SELECT
	[UserKey] AS [Deal Updated By Key]
	,[FirstName] AS [First Name (Deal Updated By)]
	,[LastName] AS [Last Name (Deal Updated By)]
	,[FullName] AS [Full Name (Deal Updated By)]
FROM
	DimUser

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal Updated By] TO [DataServices]
    AS [dbo];

