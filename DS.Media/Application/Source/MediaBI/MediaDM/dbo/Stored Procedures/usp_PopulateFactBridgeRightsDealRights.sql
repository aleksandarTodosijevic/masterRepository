create PROCEDURE [dbo].[usp_PopulateFactBridgeRightsDealRights]
AS

TRUNCATE TABLE  [dbo].[FactBridgeRightsDealRights]

INSERT  dbo.FactBridgeRightsDealRights
           (RightsTreeKey, DealRightsKey, RightsTreeId, OrderDetailRightsDetailId)
SELECT 	
	 k.[generatedkey] AS [RightTreeKey]
	,k.generatedkey2 AS [DealRightsKey]
	,RightsTreeId
	,OrderDetailRightsDetailId
FROM 
(
	SELECT 
		rs.RightsTreeId
		,drd.Id AS OrderDetailRightsDetailId
	FROM [$(MediaDMStaging)].[dbo].[RightsSelection] rs
	INNER JOIN [$(MediaDMStaging)].[dbo].[OrderDetailRightsDetail] drd ON rs.RightsSelectionId = drd.RightsSelectionId
	WHERE rs.StatusId = 1
) AS tt
CROSS APPLY [dbo].[ufn_GenerateKey](RightsTreeId,OrderDetailRightsDetailId) as k

RETURN 0