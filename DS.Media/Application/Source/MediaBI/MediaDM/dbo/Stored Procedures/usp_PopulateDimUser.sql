CREATE PROCEDURE [dbo].[usp_PopulateDimUser]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimUser') IS NOT NULL DROP TABLE #DimUser

SELECT * INTO #DimUser FROM dbo.DimUser WHERE 1 = 2;


;WITH CTE_LastLogin
AS
(
	SELECT UserId,MAX(CreatedDate)  AS LastLogin FROM [$(MediaDMStaging)].[dbo].[UserLoginHistory]
	GROUP BY UserId
)
INSERT INTO #DimUser 
(UserKey, SourceUserId, FirstName, LastName, FullName, [LoginId], [SystemRole], [Locked], [Status], [LastLoginDate], Email, PreferencesJson, HashKey, DeletedOn)
SELECT 
	 UserKey
	,SourceUserId
	,FirstName
	,LastName
	,FullName
	,LoginId
	,SystemRole
	,Locked
	,[Status]
	,LastLoginDate
	,Email
	,PreferencesJson
    ,dbo.ufn_GetHashDimUser(UserKey, SourceUserId, FirstName, LastName, FullName, [LoginId], [SystemRole], [Locked], [Status], [LastLoginDate], Email, PreferencesJson) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(u.Id) as UserKey
	,u.Id as SourceUserId
	,Firstname
	,Lastname
	,Firstname + ' ' + Lastname AS FullName
	,COALESCE([LoginId],'N/A') AS [LoginId]
	,COALESCE(sr.[Description],'N/A') AS [SystemRole]
	,CASE 
		WHEN [Locked] = 1 THEN 'Yes'
		WHEN [Locked] = 0 THEN 'No'
		ELSE 'N/A'
	END AS [Locked]
	,CASE WHEN u.[StatusId] = 1 THEN 'Active'
		WHEN u.[StatusId] = 2 THEN 'Inactive'
	END AS [Status]
--	,ISNULL(lg.LastLogin, '1900-01-01') AS LastLoginDate
    ,lg.LastLogin AS LastLoginDate
	,COALESCE(u.Email,'Unknown') AS Email
	,COALESCE(u.PreferencesJson,'N/A') AS PreferencesJson
FROM [$(MediaDMStaging)].dbo.[User] u
LEFT JOIN CTE_LastLogin lg ON u.Id = lg.UserId
LEFT JOIN [$(MediaDMStaging)].dbo.[SystemRole_lu] sr ON u.SystemRoleId = sr.Id
WHERE sr.StatusId = 1 OR sr.StatusId IS NULL

UNION ALL

SELECT
	dbo.CreateKeyFromSourceID(-1) as UserKey
	,-1 as SourceUserId
	,'Unknown' AS Firstname
	,'Unknown' AS Lastname
	,'Unknown' AS FullName
	,'Unknown' AS  [LoginId] 
	,'Unknown'  AS [SystemRole] 
	,'N/A' AS [Locked]
	,'Unknown' AS [Status]
	,NULL AS [LastLoginDate]
	,'Unknown' AS [Email]
	,'N/A' AS [PreferencesJson]
) tt;

MERGE 
    dbo.DimUser t
USING 
    #DimUser s ON (t.UserKey = s.UserKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.UserKey = s.UserKey
		,t.SourceUserId = s.SourceUserId
		,t.FirstName = s.FirstName
		,t.LastName = s.LastName
		,t.FullName = s.FullName
		,t.LoginId = s.LoginId
		,t.SystemRole = s.SystemRole
		,t.Locked = s.Locked
		,t.[Status] = s.[Status]
		,t.LastLoginDate = s.LastLoginDate
		,t.Email = s.Email
		,t.PreferencesJson = s.PreferencesJson
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (UserKey, SourceUserId, FirstName, LastName, FullName, [LoginId], [SystemRole], [Locked], [Status], [LastLoginDate], Email, PreferencesJson, HashKey)
    VALUES (s.UserKey, s.SourceUserId, s.FirstName, s.LastName, s.FullName, s.[LoginId], s.[SystemRole], s.[Locked], s.[Status], s.[LastLoginDate], s.Email, s.PreferencesJson, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimUser] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimUser] TO [DataServices]
    AS [dbo];
GO
