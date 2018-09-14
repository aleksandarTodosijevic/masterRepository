cReate FUNCTION [dbo].[ufn_GetHashFactUserRoles]
(    @CountOfRoles INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CountOfRoles AS CountOfRoles
	FOR XML RAW('r')))
END