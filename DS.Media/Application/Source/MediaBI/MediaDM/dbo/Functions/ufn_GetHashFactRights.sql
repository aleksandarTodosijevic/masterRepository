CREATE FUNCTION [dbo].[ufn_GetHashFactRights]
(    @LicenseStartDateKey INT
    ,@LicenseEndDateKey INT
	,@PropertyKey BIGINT
	,@ProjectionKey BIGINT
	,@DealPropertyKey BIGINT
	,@DealRightsKey BIGINT
	,@PropertyRightsKey BIGINT
	,@EntertainmentShippedDateKey INT
	,@RecognitionDateKey INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @LicenseStartDateKey AS LicenseStartDateKey
    ,@LicenseEndDateKey AS LicenseEndDateKey
	,@PropertyKey AS PropertyKey
	,@ProjectionKey AS ProjectionKey
	,@DealPropertyKey AS DealPropertyKey
	,@DealRightsKey AS DealRightsKey
	,@PropertyRightsKey AS PropertyRightsKey
	,@EntertainmentShippedDateKey AS EntertainmentShippedDateKey
	,@RecognitionDateKey AS RecognitionDateKey
	FOR XML RAW('r')))
END