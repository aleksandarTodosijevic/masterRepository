
CREATE PROCEDURE [dbo].[usp_PopulateFactComments]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#FactComments') IS NOT NULL DROP TABLE #FactComments

SELECT * INTO #FactComments FROM dbo.FactComments WHERE 1 = 2;


INSERT INTO #FactComments 
   (CommentKey, CustomerContactKey, CreatedByKey, CreatedOnDateKey, UpdatedByKey, UpdatedOnDateKey, HashKey, DeletedOn)
SELECT 
	 CommentKey
	,CustomerContactKey
	,CreatedByKey
	,CreatedOnDateKey
	,UpdatedByKey
	,UpdatedOnDateKey
	,dbo.ufn_GetHashFactComments(CreatedByKey, CreatedOnDateKey, UpdatedByKey, UpdatedOnDateKey) AS HashKey
    ,NULL AS DeletedOn
FROM (

SELECT
	dbo.CreateKeyFromSourceID('O' + CONVERT(VARCHAR(10),c.Id)) as CommentKey
	,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), COALESCE(o.CustomerId,-1))+':-1:-1') as CustomerContactKey
	,dbo.CreateKeyFromSourceID(c.CreatedBy) as CreatedByKey
	,dbo.CreateKeyFromDate(c.CreatedDate) AS CreatedOnDateKey
	,dbo.CreateKeyFromSourceID(COALESCE(c.UpdatedBy, c.CreatedBy)) as UpdatedByKey
	,dbo.CreateKeyFromDate(COALESCE(c.UpdatedDate, c.CreatedDate)) AS UpdatedOnDateKey
FROM
	[$(MediaDMStaging)].dbo.OrderComment c
	LEFT JOIN [$(MediaDMStaging)].dbo.OrderHeader o
		ON o.Id = c.OrderHeaderId
WHERE
	c.StatusId = 1
	AND c.CreatedBy <> 1
UNION ALL
SELECT
	dbo.CreateKeyFromSourceID('C' + CONVERT(VARCHAR(10),c.Id)) as CommentKey
	,dbo.CreateKeyFromSourceID(CONVERT(VARCHAR(10), COALESCE(c.CustomerId,-1))+':-1:-1') as CustomerContactKey
	,dbo.CreateKeyFromSourceID(c.CreatedBy) as CreatedByKey
	,dbo.CreateKeyFromDate(c.CreatedDate) AS CreatedOnDateKey
	,dbo.CreateKeyFromSourceID(COALESCE(c.UpdatedBy, c.CreatedBy)) as UpdatedByKey
	,dbo.CreateKeyFromDate(COALESCE(c.UpdatedDate, c.CreatedDate)) AS UpdatedOnDateKey
FROM
	[$(MediaDMStaging)].dbo.CustomerComment c
WHERE
	c.StatusId = 1
	AND c.CreatedBy <> 1
) tt;


MERGE 
    dbo.FactComments AS t
USING 
    #FactComments AS s ON (
			    t.CommentKey = s.CommentKey
			AND t.CustomerContactKey = s.CustomerContactKey
					 )
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
			t.CreatedByKey = s.CreatedByKey
		   ,t.CreatedOnDateKey = s.CreatedOnDateKey
		   ,t.UpdatedByKey = s.UpdatedByKey
		   ,t.UpdatedOnDateKey = s.UpdatedOnDateKey
		   ,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CommentKey, CustomerContactKey, CreatedByKey, CreatedOnDateKey, UpdatedByKey, UpdatedOnDateKey, HashKey)
    VALUES (s.CommentKey, s.CustomerContactKey, s.CreatedByKey, s.CreatedOnDateKey, s.UpdatedByKey, s.UpdatedOnDateKey, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactComments] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactComments] TO [DataServices]
    AS [dbo];
GO

