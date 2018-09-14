CREATE PROCEDURE [dbo].[usp_PopulateDimUserBillingCompany]
AS

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimUserBillingCompany') IS NOT NULL DROP TABLE #DimUserBillingCompany

SELECT * INTO #DimUserBillingCompany FROM dbo.DimUserBillingCompany WHERE 1 = 2;


INSERT INTO #DimUserBillingCompany
           ([UserBillingCompanyKey]
           ,[BillingCompanyId]
           ,[BillingCompany]
		   ,[HashKey]
		   ,[DeletedOn])
SELECT 
	 [UserBillingCompanyKey]
    ,[BillingCompanyId]
    ,[BillingCompany]
    ,dbo.ufn_GetHashDimUserBillingCompany([UserBillingCompanyKey], [BillingCompanyId], [BillingCompany]) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT 
	 dbo.CreateKeyFromSourceID(ubc.Id) AS UserBillingCompanyKey
	,ubc.BillingCompanyId
	,bc.[Description] AS BillingCompany
FROM [$(MediaDMStaging)].[dbo].UserBillingCompany ubc
INNER JOIN [$(MediaDMStaging)].[dbo].[BillingCompany_lu] AS bc WITH (NOLOCK) ON bc.Id = ubc.BillingCompanyId

UNION ALL

SELECT
	dbo.CreateKeyFromSourceID(-1) AS UserBillingCompanyKey,
	-1 AS BillingCompanyId,
	'N/A' AS BillingCompany
) tt;

MERGE 
    dbo.DimUserBillingCompany t
USING 
    #DimUserBillingCompany s ON (t.UserBillingCompanyKey = s.UserBillingCompanyKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.[UserBillingCompanyKey] = s.[UserBillingCompanyKey]
		,t.[BillingCompanyId] = s.[BillingCompanyId]
		,t.[BillingCompany] = s.[BillingCompany]
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([UserBillingCompanyKey], [BillingCompanyId], [BillingCompany], HashKey)
    VALUES (s.[UserBillingCompanyKey], s.[BillingCompanyId], s.[BillingCompany], s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimUserBillingCompany] TO [ETLRole]
    AS [dbo];

GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimUserBillingCompany] TO [DataServices]
    AS [dbo];
GO
