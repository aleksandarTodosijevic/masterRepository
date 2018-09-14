cReate FUNCTION [dbo].[ufn_GetHashFactUserProjectionNumbers]
(    @CountOfProjectionNumbers INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CountOfProjectionNumbers AS CountOfProjectionNumbers
	FOR XML RAW('r')))
END