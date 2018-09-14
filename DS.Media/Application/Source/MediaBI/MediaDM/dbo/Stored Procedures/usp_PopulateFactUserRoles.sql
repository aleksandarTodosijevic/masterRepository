CREATE PROCEDURE [dbo].[usp_PopulateFactUserRoles]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactUserRoles') IS NOT NULL DROP TABLE #FactUserRoles

SELECT * INTO #FactUserRoles FROM dbo.FactUserRoles WHERE 1 = 2;

INSERT INTO #FactUserRoles 
   (UserKey, RoleKey, CountOfRoles, HashKey, DeletedOn)
SELECT 
	 UserKey
	,RoleKey
	,CountOfRoles
--	,dbo.ufn_GetHashFactUserRoles(CountOfRoles) AS HashKey
	,NULL HashKey
    ,NULL AS DeletedOn
FROM (

SELECT 
	dbo.CreateKeyFromSourceID(u.Id) AS UserKey
	,dbo.CreateKeyFromSourceID(COALESCE(ur.RoleId, -1)) AS RoleKey
	,CASE WHEN ur.Id IS NULL THEN 0 ELSE 1 END AS CountOfRoles
FROM [$(MediaDMStaging)].[dbo].[User] u 
	LEFT JOIN [$(MediaDMStaging)].[dbo].[UserRole] ur ON u.Id = ur.UserId 
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Role_lu] r ON ur.Id = r.Id
WHERE (ur.StatusId = 1 OR ur.StatusId IS NULL)
) tt;
	
MERGE 
    dbo.FactUserRoles AS t
USING 
    #FactUserRoles AS s ON (
				t.[UserKey] = s.[UserKey]
			AND	t.[RoleKey] = s.[RoleKey]
					 )
WHEN NOT MATCHED BY TARGET THEN
    INSERT (UserKey, RoleKey, CountOfRoles, HashKey)
    VALUES (s.UserKey, s.RoleKey, 1, NULL)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactUserRoles] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactUserRoles] TO [DataServices]
    AS [dbo];
GO


