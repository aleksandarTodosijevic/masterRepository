Create FUNCTION [dbo].[ufn_GetHashDimUserProjectionNumber]
(
	 @UserProjectionNumberKey BIGINT
	,@ProjectionNumberNo VARCHAR(10)
	,@ProjectionNumber VARCHAR(30)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @UserProjectionNumberKey AS UserProjectionNumberKey
	,@ProjectionNumberNo AS ProjectionNumberNo
	,@ProjectionNumber AS ProjectionNumber
	FOR XML RAW('r')))
END