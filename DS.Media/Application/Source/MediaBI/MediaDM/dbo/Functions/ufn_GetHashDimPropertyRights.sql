Create FUNCTION [dbo].[ufn_GetHashDimPropertyRights]
(
	 @PropertyRightsKey BIGINT
	,@SourcePropertyRightsId INT
	,@RightsSelection VARCHAR(2048)
	,@TerritorySelection VARCHAR(2048)
	,@LanguageSelection VARCHAR(2048)
	,@LicenseStartDate DATETIME
	,@LicenseEndDate DATETIME
	,@InPerpetuity VARCHAR(3)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @PropertyRightsKey AS PropertyRightsKey
	,@SourcePropertyRightsId AS SourcePropertyRightsId
	,@RightsSelection AS RightsSelection
	,@TerritorySelection AS TerritorySelection
	,@LanguageSelection AS LanguageSelection
	,@LicenseStartDate AS LicenseStartDate
	,@LicenseEndDate AS LicenseEndDate
	,@InPerpetuity AS InPerpetuity
	FOR XML RAW('r')))
END