Create FUNCTION [dbo].[ufn_GetHashDimProjectionTerritory]
(
	 @ProjectionTerritoryKey BIGINT
	,@SourceTerritoryId INT
	,@TerritoryRegion VARCHAR(50)
	,@TerritoryName VARCHAR(50)
	,@TerritoryTreeId INT
	,@TerritoryTreeParentId INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @ProjectionTerritoryKey AS ProjectionTerritoryKey
	,@SourceTerritoryId AS SourceTerritoryId
	,@TerritoryRegion AS TerritoryRegion
	,@TerritoryName AS TerritoryName
	,@TerritoryTreeId AS TerritoryTreeId
	,@TerritoryTreeParentId AS TerritoryTreeParentId
	FOR XML RAW('r')))
END