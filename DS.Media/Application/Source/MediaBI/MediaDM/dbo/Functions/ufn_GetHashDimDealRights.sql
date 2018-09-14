Create FUNCTION [dbo].[ufn_GetHashDimDealRights]
(
	 @DealRightKey BIGINT
	,@SourceDealRightsId INT
	,@DealRightsDescription VARCHAR(2048)
	,@Exclusive VARCHAR(3)
	,@TerritoryDescription VARCHAR(2048)
	,@LanguageDescription VARCHAR(2048)
	,@LicenseStart DATETIME
	,@LicenseEnd DATETIME
	,@NumberOfTransmissions INT
	,@NumberOfTransmissionsName VARCHAR(30)
	,@InPerpetuity VARCHAR(3)
	,@LicenseDuration INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @DealRightKey AS DealRightKey
	,@SourceDealRightsId AS SourceDealRightsId
	,@DealRightsDescription AS DealRightsDescription
	,@Exclusive AS Exclusive
	,@TerritoryDescription AS TerritoryDescription
	,@LanguageDescription AS LanguageDescription
	,@LicenseStart AS LicenseStart
	,@LicenseEnd AS LicenseEnd
	,@NumberOfTransmissions AS NumberOfTransmissions
	,@NumberOfTransmissionsName AS NumberOfTransmissionsName
	,@InPerpetuity AS InPerpetuity
	,@LicenseDuration AS LicenseDuration
	FOR XML RAW('r')))
END