Create FUNCTION [dbo].[ufn_GetHashDimProjection]
(
	 @ProjectionKey BIGINT
	,@ProjectionNo VARCHAR(10)
	,@ProjectionNoT VARCHAR(10)
	,@ProjectionName VARCHAR(30)
	,@ProjectionNameT VARCHAR(30)
	,@SubjectCategory VARCHAR(50)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @ProjectionKey AS ProjectionKey
	,@ProjectionNo AS ProjectionNo
	,@ProjectionNoT AS ProjectionNoT
	,@ProjectionName AS ProjectionName
	,@ProjectionNameT AS ProjectionNameT
	,@SubjectCategory AS SubjectCategory
	FOR XML RAW('r')))
END