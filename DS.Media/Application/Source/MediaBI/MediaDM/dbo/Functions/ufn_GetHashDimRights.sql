cREate FUNCTION [dbo].[ufn_GetHashDimRights]
(
    @RightsTreeKey BIGINT
    ,@RightsTreeId INT
    ,@RightsTreeParentId INT
    ,@RightsName VARCHAR(50)

)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
		@RightsTreeKey AS RightsTreeKey
		,@RightsTreeId AS RightsTreeId
		,@RightsTreeParentId AS RightsTreeParentId
		,@RightsName AS RightsName
	FOR XML RAW('r')))
END