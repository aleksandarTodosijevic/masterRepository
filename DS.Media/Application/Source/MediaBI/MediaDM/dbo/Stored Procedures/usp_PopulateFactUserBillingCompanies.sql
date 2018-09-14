
CREATE PROCEDURE [dbo].[usp_PopulateFactUserBillingCompanies]

AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactUserBillingCompanies') IS NOT NULL DROP TABLE #FactUserBillingCompanies

SELECT * INTO #FactUserBillingCompanies FROM dbo.FactUserBillingCompanies WHERE 1 = 2;


INSERT INTO #FactUserBillingCompanies 
   ([UserBillingCompanyKey], [UserKey], [CountOfBillingCompanies], HashKey, DeletedOn)
SELECT 
	 [UserBillingCompanyKey]
    ,[UserKey]
    ,[CountOfBillingCompanies]
--	,dbo.ufn_GetHashFactUserBillingCompanies(CountOfBillingCompanies) AS HashKey
	,NULL HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(ubc.Id) AS UserBillingCompanyKey,
	dbo.CreateKeyFromSourceID(CASE WHEN COALESCE(ubc.UserId,-1) = 5869 THEN -1 ELSE COALESCE(ubc.UserId,-1) END) AS UserKey,
	1 AS CountOfBillingCompanies
FROM [$(MediaDMStaging)].[dbo].[UserBillingCompany] AS ubc
WHERE ubc.StatusId = 1
) tt;

MERGE 
    dbo.FactUserBillingCompanies AS t
USING 
    #FactUserBillingCompanies AS s ON (
				t.[UserBillingCompanyKey] = s.[UserBillingCompanyKey]
			AND	t.[UserKey] = s.[UserKey]
					 )
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([UserBillingCompanyKey], [UserKey], [CountOfBillingCompanies], HashKey)
    VALUES (s.[UserBillingCompanyKey], s.[UserKey], 1, NULL)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;





RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactUserBillingCompanies] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactUserBillingCompanies] TO [DataServices]
    AS [dbo];
GO

