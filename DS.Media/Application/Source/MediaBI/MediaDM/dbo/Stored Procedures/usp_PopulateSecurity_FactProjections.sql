
CREATE PROCEDURE [dbo].[usp_PopulateSecurity_FactProjections]

AS

EXEC usp_TruncateTable 'dbo', 'Security_FactProjections';

INSERT INTO [dbo].[Security_FactProjections]

SELECT dp.ProjectionKey
	,dbo.CreateKeyFromSourceID(u.Id) AS UserKey
	,up.ProjectionNo
FROM [$(MediaDMStaging)].[dbo].[User] u
INNER JOIN [$(MediaDMStaging)].[dbo].[UserProjectionNumber] up ON u.Id = up.UserId
INNER JOIN [dbo].[DimProjection] dp ON up.ProjectionNo = dp.ProjectionNo

UNION ALL

SELECT dp.ProjectionKey
	,dbo.CreateKeyFromSourceID(-2) AS UserKey
	,up.ProjectionNo
FROM [$(MediaDMStaging)].[dbo].[User] u
INNER JOIN [$(MediaDMStaging)].[dbo].[UserProjectionNumber] up ON u.Id = up.UserId
INNER JOIN [dbo].[DimProjection] dp ON up.ProjectionNo = dp.ProjectionNo
WHERE u.Id = 4716

UNION ALL

SELECT dp.ProjectionKey
	,dbo.CreateKeyFromSourceID(u.Id) AS UserKey
	,dp.ProjectionNo
FROM [$(MediaDMStaging)].[dbo].[User] u
CROSS JOIN [dbo].[DimProjection] dp 
WHERE u.LoginId = 'Mali9000'



RETURN 0;
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateSecurity_FactProjections] TO [DataServices]
    AS [dbo];
GO
