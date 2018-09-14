Create FUNCTION [dbo].[ufn_GetHashDimCustomerContact]
(
	 @CustomerContactKey BIGINT
	,@SourceCustomerId INT
	,@SourceContactId INT
	,@SourceCustomerAddressId INT
	,@CustomerNo INT
	,@CustomerName VARCHAR(80)
	,@CustomerShortName VARCHAR(20)
	,@ContactName VARCHAR(35)
	,@ProjectionTerritory VARCHAR(50)
	,@SAPCustomerNumber VARCHAR(10)
	,@SAPPayerNumber VARCHAR(10)
	,@SOLId INT
	,@RightsSelection VARCHAR(2048)
	,@TerritorySelection VARCHAR(2048)
	,@LanguageSelection VARCHAR(2048)
	,@NumberOfTransmissions INT
	,@NumberOfTransmissionsName VARCHAR(30)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @CustomerContactKey AS CustomerContactKey
	,@SourceCustomerId AS SourceCustomerId
	,@SourceContactId AS SourceContactId
	,@SourceCustomerAddressId AS SourceCustomerAddressId
	,@CustomerNo AS CustomerNo
	,@CustomerName AS CustomerName
	,@CustomerShortName AS CustomerShortName
	,@ContactName AS ContactName
	,@ProjectionTerritory AS ProjectionTerritory
	,@SAPCustomerNumber AS SAPCustomerNumber
	,@SAPPayerNumber AS SAPPayerNumber
	,@SOLId AS SOLId
	,@RightsSelection AS RightsSelection
	,@TerritorySelection AS TerritorySelection
	,@LanguageSelection AS LanguageSelection
	,@NumberOfTransmissions AS NumberOfTransmissions
	,@NumberOfTransmissionsName AS NumberOfTransmissionsName
	FOR XML RAW('r')))
END