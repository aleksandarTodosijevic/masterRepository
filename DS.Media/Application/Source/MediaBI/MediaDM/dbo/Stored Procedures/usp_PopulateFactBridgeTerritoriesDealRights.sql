CREATE PROCEDURE [dbo].[usp_PopulateFactBridgeTerritoriesDealRights]
AS

TRUNCATE TABLE  [dbo].[FactBridgeTerritoriesDealRights]

INSERT  dbo.FactBridgeTerritoriesDealRights
           (TerritoryTreeKey, DealRightsKey, TerritoryTreeId, OrderDetailRightsDetailId)
SELECT 	
	k.[generatedkey] AS [TerritoryTreeKey]
	,k.generatedkey2 AS [DealRightsKey]
	,TerritoryTreeId
	,OrderDetailRightsDetailId
FROM 
(
	SELECT 
		ts.TerritoryTreeId
		,drd.Id AS OrderDetailRightsDetailId
	FROM [$(MediaDMStaging)].[dbo].[TerritorySelection] ts
	INNER JOIN [$(MediaDMStaging)].[dbo].[OrderDetailRightsDetail] drd ON ts.TerritorySelectionId = drd.TerritorySelectionId
	WHERE ts.StatusId = 1
) AS tt
CROSS APPLY [dbo].[ufn_GenerateKey](TerritoryTreeId,OrderDetailRightsDetailId) as k

RETURN 0

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateFactBridgeTerritoriesDealRights] TO [ETLRole]
    AS [dbo];
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateFactBridgeTerritoriesDealRights] TO [DataServices]
    AS [dbo];
GO