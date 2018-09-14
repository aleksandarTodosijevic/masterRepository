CREATE PROCEDURE [dbo].[usp_PopulateSecurity_FactSalesAreas]

AS
		
EXEC usp_TruncateTable 'dbo', 'Security_FactSalesAreas';

INSERT INTO [dbo].[Security_FactSalesAreas]
Select 
	dbo.CreateKeyFromSourceID(usa.SalesAreaId) AS SalesAreaKey,
	dbo.CreateKeyFromSourceID(u.Id) AS UserKey
FROM [$(MediaDMStaging)].[dbo].[User] AS u
INNER JOIN [$(MediaDMStaging)].[dbo].[UserSalesArea] AS usa ON u.Id = usa.UserId
WHERE usa.Write = 1 AND u.LoginId NOT LIKE 'Mali9000'


/*** for testing purposes    *****/	

INSERT INTO [dbo].[Security_FactSalesAreas]
Select 
	dbo.CreateKeyFromSourceID(usa.SalesAreaId) AS SalesAreaKey,
	dbo.CreateKeyFromSourceID(-2) AS UserKey
FROM [$(MediaDMStaging)].[dbo].[User] AS u
INNER JOIN [$(MediaDMStaging)].[dbo].[UserSalesArea] AS usa ON u.Id = usa.UserId
WHERE usa.Write = 1 AND u.LoginId = 'barn7397'

UNION

Select 
	dbo.CreateKeyFromSourceID(usa.SalesAreaId) AS SalesAreaKey,
	dbo.CreateKeyFromSourceID(5719) AS UserKey
FROM [$(MediaDMStaging)].[dbo].[User] AS u
INNER JOIN [$(MediaDMStaging)].[dbo].[UserSalesArea] AS usa ON u.Id = usa.UserId
WHERE usa.Write = 1 AND  u.LoginId = 'barn7397'

UNION

Select 
	dbo.CreateKeyFromSourceID(usa.SalesAreaId) AS SalesAreaKey,
	dbo.CreateKeyFromSourceID(-3) AS UserKey
FROM [$(MediaDMStaging)].[dbo].[User] AS u
INNER JOIN [$(MediaDMStaging)].[dbo].[UserSalesArea] AS usa ON u.Id = usa.UserId
WHERE usa.Write = 1 AND  u.LoginId = 'barn7397'

RETURN 0;

GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateSecurity_FactSalesAreas] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateSecurity_FactSalesAreas] TO [DataServices]
    AS [dbo];
GO
