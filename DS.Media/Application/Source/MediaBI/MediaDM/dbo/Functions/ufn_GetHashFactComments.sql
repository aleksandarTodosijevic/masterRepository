cReate FUNCTION [dbo].[ufn_GetHashFactComments]
(    @CreatedByKey BIGINT
    ,@CreatedOnDateKey INT
    ,@UpdatedByKey BIGINT
    ,@UpdatedOnDateKey INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CreatedByKey AS CreatedByKey
    ,@CreatedOnDateKey AS CreatedOnDateKey
    ,@UpdatedByKey AS UpdatedByKey
    ,@UpdatedOnDateKey AS UpdatedOnDateKey
	FOR XML RAW('r')))
END