Create FUNCTION [dbo].[ufn_GetHashDimDelivery]
(
	 @DeliveryKey BIGINT
	,@Property VARCHAR(50)
	,@Label VARCHAR(50)
	,@BroadcastType VARCHAR(50)
	,@GeneralType VARCHAR(50)
	,@Version VARCHAR(70)
	,@FeedCoordination VARCHAR(50)
	,@ShipDate DATETIME
	,@VideoStandard VARCHAR(50)
	,@AspectRation VARCHAR(50)
	,@ShippedDate DATETIME
	,@AWBNumber VARCHAR(20)
	,@IsOnHold VARCHAR(3)
	,@Language VARCHAR(50)
	,@TapeFormat VARCHAR(50)
	,@AudioFormat VARCHAR(50)
	,@NumberOfTapes INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @DeliveryKey AS DeliveryKey
	,@Property AS Property
	,@Label AS Label
	,@BroadcastType AS BroadcastType
	,@GeneralType AS GeneralType
	,@Version AS Version
	,@FeedCoordination AS FeedCoordination
	,@ShipDate AS ShipDate
	,@VideoStandard AS VideoStandard
	,@AspectRation AS AspectRation
	,@ShippedDate AS ShippedDate
	,@AWBNumber AS AWBNumber
	,@IsOnHold AS IsOnHold
	,@Language AS Language
	,@TapeFormat AS TapeFormat
	,@AudioFormat AS AudioFormat
	,@NumberOfTapes AS NumberOfTapes
	FOR XML RAW('r')))
END