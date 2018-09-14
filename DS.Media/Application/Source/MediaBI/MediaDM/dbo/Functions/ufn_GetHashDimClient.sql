Create FUNCTION [dbo].[ufn_GetHashDimClient]
(
	@ClientKey BIGINT
	,@ClientNo VARCHAR(10)
	,@ClientNoInt INT
	,@ClientName VARCHAR(80)
	,@ClientName2 VARCHAR(80)
	,@ClientFullName VARCHAR(160)
	,@ClientAddress VARCHAR(309)
	,@ClientCountry VARCHAR(80)
	,@IsIMGClient VARCHAR(3)
	,@IsProjectionClient VARCHAR(3)
	,@IsUltimateOwner VARCHAR(3)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
		@ClientKey AS ClientKey
		,@ClientNo AS ClientNo
		,@ClientNoInt AS ClientNoInt
		,@ClientName AS ClientName
		,@ClientName2 AS ClientName2
		,@ClientFullName AS ClientFullName
		,@ClientAddress AS ClientAddress
		,@ClientCountry AS ClientCountry
		,@IsIMGClient AS IsIMGClient
		,@IsProjectionClient AS IsProjectionClient
		,@IsUltimateOwner AS IsUltimateOwner
	FOR XML RAW('r')))
END