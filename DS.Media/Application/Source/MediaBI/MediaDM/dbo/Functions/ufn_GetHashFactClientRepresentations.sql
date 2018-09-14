cReate FUNCTION [dbo].[ufn_GetHashFactClientRepresentations]
(    @UltimateOwnerKey BIGINT
    ,@IsUltimateOwner BIT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @UltimateOwnerKey AS UltimateOwnerKey
    ,@IsUltimateOwner AS IsUltimateOwner
	FOR XML RAW('r')))
END