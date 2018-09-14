

CREATE  PROCEDURE [dbo].[usp_PopulateFactUserProjectionNumbers]

AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactUserProjectionNumbers') IS NOT NULL DROP TABLE #FactUserProjectionNumbers

SELECT * INTO #FactUserProjectionNumbers FROM dbo.FactUserProjectionNumbers WHERE 1 = 2;

INSERT INTO #FactUserProjectionNumbers 
   ([UserProjectionNumberKey], [UserKey], [CountOfProjectionNumbers], HashKey, DeletedOn)
SELECT 
	 [UserProjectionNumberKey]
    ,[UserKey]
    ,[CountOfProjectionNumbers]
--	,dbo.ufn_GetHashFactUserProjectionNumbers(CountOfProjectionNumbers) AS HashKey
	,NULL AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT
	dbo.CreateKeyFromSourceID(upn.Id) AS UserProjectionNumberKey,
	dbo.CreateKeyFromSourceID(COALESCE(upn.UserId,-1)) AS UserKey,
	1 AS CountOfProjectionNumbers
FROM [$(MediaDMStaging)].[dbo].[UserProjectionNumber] AS upn
WHERE upn.StatusId = 1
) tt;

MERGE 
    dbo.FactUserProjectionNumbers AS t
USING 
    #FactUserProjectionNumbers AS s ON (
				t.[UserProjectionNumberKey] = s.[UserProjectionNumberKey]
			AND	t.[UserKey] = s.[UserKey]
					 )
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([UserProjectionNumberKey], [UserKey], [CountOfProjectionNumbers], HashKey)
    VALUES (s.[UserProjectionNumberKey], s.[UserKey], 1, NULL)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactUserProjectionNumbers] TO [ETLRole]
    AS [dbo];
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactUserProjectionNumbers] TO [DataServices]
    AS [dbo];
GO

