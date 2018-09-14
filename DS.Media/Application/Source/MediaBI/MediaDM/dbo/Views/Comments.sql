CREATE VIEW [dbo].[Comments]
AS SELECT
	CommentKey AS [Comment Key]
	,CustomerContactKey AS [Customer Contact Key]
	,CreatedByKey AS [Created By Key]
	,CreatedOnDateKey AS [Created On Date Key]
	,UpdatedByKey AS [Update By Key]
	,UpdatedOnDateKey AS [Updated On Date Key]
FROM dbo.FactComments

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Comments] TO [DataServices]
    AS [dbo];

