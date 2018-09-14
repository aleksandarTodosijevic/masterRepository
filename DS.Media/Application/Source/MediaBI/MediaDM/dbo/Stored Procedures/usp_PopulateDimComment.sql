CREATE PROCEDURE [dbo].[usp_PopulateDimComment]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimComment') IS NOT NULL DROP TABLE #DimComment
	
SELECT * INTO #DimComment FROM dbo.DimComment WHERE 1 = 2

CREATE CLUSTERED INDEX IC_CommentCommentKey ON #DimComment(CommentKey);

INSERT INTO #DimComment (CommentKey, SourceCommentId, Regarding, Description, SourceEntity, HashKey, DeletedOn)
    SELECT 
	CommentKey
	,SourceCommentId
	,Regarding
	,Description
	,SourceEntity
    ,dbo.ufn_GetHashDimComment(CommentKey, SourceCommentId, Description, Regarding, SourceEntity) AS HashKey
    ,NULL AS DeletedOn

	FROM (

	SELECT
		dbo.CreateKeyFromSourceID('O'+CONVERT(VARCHAR(10), c.Id)) as CommentKey
		,c.Id as SourceCommentId
		,c.OrderHeaderId as Regarding
		,c.Description
		,'Deal' as SourceEntity
	FROM
		[$(MediaDMStaging)].dbo.OrderComment c
	WHERE
		c.StatusId = 1
		AND c.CreatedBy <> 1
	UNION ALL
	SELECT
		dbo.CreateKeyFromSourceID('C'+CONVERT(VARCHAR(10), c.Id)) as CommentKey
		,c.Id as SourceCommentId
		,c.CustomerId as Regarding
		,c.Description
		,'Customer' as SourceEntity
	FROM
		[$(MediaDMStaging)].dbo.CustomerComment c
	WHERE
		c.StatusId = 1
		AND c.CreatedBy <> 1
) t


MERGE 
    dbo.DimComment t
USING 
    #DimComment s ON (t.CommentKey = s.CommentKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
	 	 t.CommentKey = s.CommentKey
	    ,t.SourceCommentId = s.SourceCommentId
		,t.Regarding = s.Regarding
		,t.Description = s.Description
		,t.SourceEntity = s.SourceEntity
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CommentKey, SourceCommentId, Regarding, Description, SourceEntity, HashKey)
    VALUES (s.CommentKey, s.SourceCommentId, s.Regarding, s.Description, s.SourceEntity, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimComment] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimComment] TO [DataServices]
    AS [dbo];
GO
