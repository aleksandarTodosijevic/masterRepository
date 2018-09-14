Create FUNCTION [dbo].[ufn_GetHashDimProjectionAnticipated]
(
	 @ProjectionAnticipatedKey BIGINT
	,@CreatedDateOfAnticipated DATETIME
	,@AnticipaedAmountCreatedBy VARCHAR(102)
	,@UpdatedDateOfAnticipated DATETIME
	,@AnticipatedAmountUpdatedBy VARCHAR(102)
	,@IsAppearInTotal CHAR(3)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @ProjectionAnticipatedKey AS ProjectionAnticipatedKey
	,@CreatedDateOfAnticipated AS CreatedDateOfAnticipated
	,@AnticipaedAmountCreatedBy AS AnticipaedAmountCreatedBy
	,@UpdatedDateOfAnticipated AS UpdatedDateOfAnticipated
	,@AnticipatedAmountUpdatedBy AS AnticipatedAmountUpdatedBy
	,@IsAppearInTotal AS IsAppearInTotal
	FOR XML RAW('r')))
END