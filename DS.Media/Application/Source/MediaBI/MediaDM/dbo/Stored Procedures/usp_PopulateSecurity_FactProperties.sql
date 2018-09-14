CREATE PROCEDURE [dbo].[usp_PopulateSecurity_FactProperties]

AS

EXEC usp_TruncateTable 'dbo', 'Security_FactProperties';

INSERT INTO [dbo].[Security_FactProperties]
SELECT 
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey
	,dbo.CreateKeyFromSourceID(u.Id) AS UserKey
	,p.Id AS SourceProductId
	,abr.Id AS [SourceAreaOfBusinessId]
FROM [$(MediaDMStaging)].[dbo].[Product] p
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] absr ON absr.Id = p.AreaOfBusinessSuffixId
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abr ON abr.Id = absr.AreaOfBusinessId
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abr.Id = uaob.AreaOfBusinessId
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId

UNION

/* -------   Select "Technical" products    */
SELECT 
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey
	,dbo.CreateKeyFromSourceID(u.Id) AS UserKey
	,p.Id AS SourceProductId
	,abt.Id AS [SourceAreaOfBusinessId]
FROM [$(MediaDMStaging)].[dbo].[Product] p
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] abst ON abst.Id = p.AreaOfBusinessSuffixTId
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abt ON abt.Id = abst.AreaOfBusinessId
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abt.Id = uaob.AreaOfBusinessId
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId



	
/*** for testing purposes    *****/	
INSERT INTO [dbo].[Security_FactProperties]	
SELECT 	
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey	
	,dbo.CreateKeyFromSourceID(-2) AS UserKey	
	,-2 AS SourceProductId	
	,abr.Id AS [SourceAreaOfBusinessId]	
FROM [$(MediaDMStaging)].[dbo].[Product] p	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] absr ON absr.Id = p.AreaOfBusinessSuffixId	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abr ON abr.Id = absr.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abr.Id = uaob.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId	
WHERE uaob.DomainName = 'IMGWORLD\barn7397'	
	
UNION	
	
/* -------   Select "Technical" products    */	
SELECT 	
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey	
	,dbo.CreateKeyFromSourceID(-2) AS UserKey	
	,-2 AS SourceProductId	
	,abt.Id AS [SourceAreaOfBusinessId]	
FROM [$(MediaDMStaging)].[dbo].[Product] p	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] abst ON abst.Id = p.AreaOfBusinessSuffixTId	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abt ON abt.Id = abst.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abt.Id = uaob.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId	
WHERE uaob.DomainName = 'IMGWORLD\barn7397'	
	
UNION	
	
SELECT 	
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey	
	,dbo.CreateKeyFromSourceID(5719) AS UserKey	
	,5719 AS SourceProductId	
	,abr.Id AS [SourceAreaOfBusinessId]	
FROM [$(MediaDMStaging)].[dbo].[Product] p	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] absr ON absr.Id = p.AreaOfBusinessSuffixId	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abr ON abr.Id = absr.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abr.Id = uaob.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId	
WHERE uaob.DomainName = 'IMGWORLD\barn7397'	
	
UNION	
	
/* -------   Select "Technical" products    */	
SELECT 	
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey	
	,dbo.CreateKeyFromSourceID(5719) AS UserKey	
	,5719 AS SourceProductId	
	,abt.Id AS [SourceAreaOfBusinessId]	
FROM [$(MediaDMStaging)].[dbo].[Product] p	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] abst ON abst.Id = p.AreaOfBusinessSuffixTId	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abt ON abt.Id = abst.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abt.Id = uaob.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId	
WHERE uaob.DomainName = 'IMGWORLD\barn7397'

UNION

SELECT 	
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey	
	,dbo.CreateKeyFromSourceID(-3) AS UserKey	
	,-2 AS SourceProductId	
	,abr.Id AS [SourceAreaOfBusinessId]	
FROM [$(MediaDMStaging)].[dbo].[Product] p	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] absr ON absr.Id = p.AreaOfBusinessSuffixId	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abr ON abr.Id = absr.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abr.Id = uaob.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId	
WHERE uaob.DomainName = 'IMGWORLD\barn7397'	
	
UNION	
	
/* -------   Select "Technical" products    */	
SELECT 	
	dbo.CreateKeyFromSourceID(p.Id) AS PropertyKey	
	,dbo.CreateKeyFromSourceID(-3) AS UserKey	
	,-2 AS SourceProductId	
	,abt.Id AS [SourceAreaOfBusinessId]	
FROM [$(MediaDMStaging)].[dbo].[Product] p	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusinessSuffix_lu] abst ON abst.Id = p.AreaOfBusinessSuffixTId	
INNER JOIN [$(MediaDMStaging)].[dbo].[AreaOfBusiness_lu] abt ON abt.Id = abst.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[UserAreaOfBusiness] uaob ON abt.Id = uaob.AreaOfBusinessId	
INNER JOIN [$(MediaDMStaging)].[dbo].[User] AS u ON uaob.DomainName = 'IMGWORLD\' + u.LoginId	
WHERE uaob.DomainName = 'IMGWORLD\barn7397'	


RETURN 0;

GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateSecurity_FactProperties] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateSecurity_FactProperties] TO [DataServices]
    AS [dbo];
GO

