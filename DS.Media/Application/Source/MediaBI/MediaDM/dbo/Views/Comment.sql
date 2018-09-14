CREATE VIEW [dbo].[Comment]
AS SELECT	
	d.CommentKey AS [Comment Key]
	,[SourceEntity] AS [Source Entity]
	,d.[Description] as [Description]
	,d.Regarding as [Regarding]
FROM dbo.DimComment d
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Comment] TO [DataServices]
    AS [dbo];

