cReate FUNCTION [dbo].[ufn_GetHashFactOrderDetails]
(    @DealCreatedByKey BIGINT
    ,@DealCreatedOnDateKey INT
    ,@DealUpdatedByKey BIGINT
    ,@DealUpdatedOnDateKey INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @DealCreatedByKey AS DealCreatedByKey
    ,@DealCreatedOnDateKey AS DealCreatedOnDateKey
    ,@DealUpdatedByKey AS DealUpdatedByKey
    ,@DealUpdatedOnDateKey AS DealUpdatedOnDateKey
	FOR XML RAW('r')))
END