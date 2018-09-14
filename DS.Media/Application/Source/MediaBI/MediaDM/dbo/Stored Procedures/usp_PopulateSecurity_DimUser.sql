CREATE PROCEDURE [dbo].[usp_PopulateSecurity_DimUser]
AS
	
EXEC usp_TruncateTable 'dbo', 'Security_DimUser';

INSERT INTO [dbo].[Security_DimUser]
SELECT DISTINCT
	dbo.CreateKeyFromSourceID(u.Id) AS UserKey
	,u.Id AS SourceUserId 
	,Firstname + ' ' + Lastname AS FullName
	,'IMGWORLD\' + u.LoginId AS DomainName
FROM [$(MediaDMStaging)].[dbo].[User] AS u
LEFT JOIN [$(MediaDMStaging)].[dbo].[UserSalesArea] AS usa ON u.Id = usa.UserId
LEFT JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] AS uab ON uab.DomainName = 'IMGWORLD\' + u.LoginId
LEFT JOIN [$(MediaDMStaging)].[dbo].[UserSalesPortfolio] AS usp ON u.LoginId  = usp.UserADId
LEFT JOIN [$(MediaDMStaging)].[dbo].[UserProjectionNumber] upn ON u.Id = upn.UserId
WHERE ((usa.Id IS NOT NULL) 
		OR (uab.DomainName IS NOT NULL) 
		OR (usp.UserADId IS NOT NULL) 
		OR (upn.UserId IS NOT NULL))

UNION ALL

SELECT
	dbo.CreateKeyFromSourceID(-1) AS UserKey
	,-1 AS SourceUserId
	,'Unknown' AS FullName
	,'Unknown' AS DomainName

UNION ALL

-- only for testing purposes
SELECT
	dbo.CreateKeyFromSourceID(-2) AS UserKey
	,-2 AS SourceUserId
	,'Mario Laska' AS FullName
	,'IMGWORLD\Lask9000' AS DomainName

UNION ALL

-- only for testing purposes
SELECT
	dbo.CreateKeyFromSourceID(-3) AS UserKey
	,-3 AS SourceUserId
	,'Branislav.Lesay' AS FullName
	,'IMGWORLD\Lesa9000' AS DomainName



RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateSecurity_DimUser] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateSecurity_DimUser] TO [DataServices]
    AS [dbo];
GO

