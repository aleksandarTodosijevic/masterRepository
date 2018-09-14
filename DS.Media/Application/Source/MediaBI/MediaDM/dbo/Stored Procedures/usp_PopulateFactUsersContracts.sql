CREATE PROCEDURE [dbo].[usp_PopulateFactUsersContracts]

AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactUsersContracts') IS NOT NULL DROP TABLE #FactUsersContracts

SELECT * INTO #FactUsersContracts FROM dbo.FactUsersContracts WHERE 1 = 2;


INSERT INTO #FactUsersContracts 
   ([UserContractKey], [UserKey], [CountOfContracts], HashKey, DeletedOn)
SELECT 
	 [UserContractKey]
    ,[UserKey]
    ,[CountOfContracts]
--	,dbo.ufn_GetHashFactUsersContracts(CountOfContracts) AS HashKey
	,NULL HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(uislp.Id) AS UserContractKey,
	dbo.CreateKeyFromSourceID(uislp.UserId) AS UserKey,
	1 AS CountOfContracts
FROM [$(MediaDMStaging)].[dbo].[UserIssueSiteLicensorParty] AS uislp
WHERE uislp.StatusId = 1
) tt;



MERGE 
    dbo.FactUsersContracts AS t
USING 
    #FactUsersContracts AS s ON (
				t.[UserContractKey] = s.[UserContractKey]
			AND	t.[UserKey] = s.[UserKey]
					 )
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([UserContractKey], [UserKey], [CountOfContracts], HashKey)
    VALUES (s.[UserContractKey], s.[UserKey], 1, NULL)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactUsersContracts] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactUsersContracts] TO [DataServices]
    AS [dbo];
GO


