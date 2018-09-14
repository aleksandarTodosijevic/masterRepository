CREATE FUNCTION [dbo].[ufn_GetHashDimTerritory]
(
    @TerritoryTreeKey BIGINT
    ,@TerritoryTreeId INT
    ,@TerritoryTreeParentId INT
    ,@TerritoryName VARCHAR(50)

)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
		@TerritoryTreeKey AS TerritoryTreeKey
		,@TerritoryTreeId AS TerritoryTreeId
		,@TerritoryTreeParentId AS TerritoryTreeParentId
		,@TerritoryName AS TerritoryName
	FOR XML RAW('r')))
END
