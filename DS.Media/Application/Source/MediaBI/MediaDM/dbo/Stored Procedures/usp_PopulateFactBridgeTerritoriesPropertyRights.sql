CREATE PROCEDURE [dbo].[usp_PopulateFactBridgeTerritoriesPropertyRights]
AS

TRUNCATE TABLE dbo.FactBridgeTerritoriesPropertyRights


INSERT INTO [dbo].[FactBridgeTerritoriesPropertyRights]
           ([TerritoryTreeKey]
           ,[PropertyRightsKey]
           ,[TerritoryTreeId]
           ,[DesignatedRightId])
SELECT 
	k.generatedkey AS TerritoryTreeKey
	,k.generatedkey2 AS PropertyRightsKey
	,TerritoryTreeId
	,DesignatedRightId
FROM
(
	SELECT 
		ts.TerritoryTreeId
		,dr.Id AS DesignatedRightId
	FROM [$(MediaDMStaging)].[dbo].[TerritorySelection] ts
	INNER JOIN [$(MediaDMStaging)].[dbo].[DesignatedRight] dr ON ts.TerritorySelectionId = dr.TerritorySelectionId
	WHERE ts.StatusId = 1
) AS tt
CROSS APPLY [dbo].[ufn_GenerateKey](TerritoryTreeId,DesignatedRightId) k




RETURN 0

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactBridgeTerritoriesPropertyRights] TO [ETLRole]
    AS [dbo];

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactBridgeTerritoriesPropertyRights] TO [DataServices]
    AS [dbo];