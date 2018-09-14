

CREATE VIEW [dbo].[User Projection Numbers]
	AS 
SELECT 
	[UserProjectionNumberKey] AS [User Billing Company Key],
	UserKey AS [User Key],
	CountOfProjectionNumbers AS [CountOfProjectionNumbers_]
FROM [FactUserProjectionNumbers]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Projection Numbers] TO [DataServices]
    AS [dbo];

