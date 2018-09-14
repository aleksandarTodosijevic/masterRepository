cReate FUNCTION [dbo].[ufn_GetHashFactUsersContracts]
(    @CountOfContracts INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CountOfContracts AS CountOfContracts
	FOR XML RAW('r')))
END