create FUNCTION [dbo].[ufn_GetHashDimPropertyVersion]
(
	 @PropertyKey BIGINT
	,@BroadcastType VARCHAR(50)
	,@VersionName VARCHAR(70)
	,@AvailabilityDate DATETIME
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @PropertyKey AS PropertyKey
	,@BroadcastType AS BroadcastType
	,@VersionName AS VersionName
	,@AvailabilityDate AS AvailabilityDate
	FOR XML RAW('r')))
END