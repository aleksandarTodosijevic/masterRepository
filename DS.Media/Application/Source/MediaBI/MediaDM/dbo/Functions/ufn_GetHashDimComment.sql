CREATE FUNCTION [dbo].[ufn_GetHashDimComment]
(
	 @CommentKey BIGINT
	,@SourceCommentId VARCHAR(11)
	,@Description VARCHAR(3000)
	,@Regarding INT
	,@SourceEntity VARCHAR(10)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CommentKey AS CommentKey
	,@SourceCommentId AS SourceCommentId
	,@Description AS Description
	,@Regarding AS Regarding
	,@SourceEntity AS SourceEntity

	FOR XML RAW('r')))
END