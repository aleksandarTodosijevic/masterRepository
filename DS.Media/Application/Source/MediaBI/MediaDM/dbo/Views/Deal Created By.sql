CREATE VIEW [dbo].[Deal Created By]
AS
	
SELECT
	[UserKey] AS [Deal Created By Key]
	,[FirstName] AS [First Name (Deal Created By)]
	,[LastName] AS [Last Name (Deal Created By)]
	,[FullName] AS [Full Name (Deal Created By)]
FROM
	DimUser

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal Created By] TO [DataServices]
    AS [dbo];

