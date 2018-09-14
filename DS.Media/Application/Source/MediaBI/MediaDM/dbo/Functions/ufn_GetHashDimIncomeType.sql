Create FUNCTION [dbo].[ufn_GetHashDimIncomeType]
(
	 @IncomeTypeKey BIGINT
	,@SourceIncomeTypeId INT
	,@SalesCategory VARCHAR(50)
	,@FeeType VARCHAR(9)
	,@FeeDescription VARCHAR(50)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @IncomeTypeKey AS IncomeTypeKey
	,@SourceIncomeTypeId AS SourceIncomeTypeId
	,@SalesCategory AS SalesCategory
	,@FeeType AS FeeType
	,@FeeDescription AS FeeDescription
	FOR XML RAW('r')))
END