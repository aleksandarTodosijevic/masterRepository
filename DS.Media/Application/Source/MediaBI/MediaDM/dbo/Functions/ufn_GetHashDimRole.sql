Create FUNCTION [dbo].[ufn_GetHashDimRole]
(
	 @RoleKey BIGINT
	,@NameOfRole VARCHAR(50)
	,@CommentOfRole VARCHAR(255)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @RoleKey AS RoleKey
	,@NameOfRole AS NameOfRole
	,@CommentOfRole AS CommentOfRole
	FOR XML RAW('r')))
END