create PROCEDURE [dbo].[usp_PopulateFactBridgeTerritoriesPipelineDeals]
AS

TRUNCATE TABLE  [dbo].[FactBridgeTerritoriesPipelineDeals]

INSERT  dbo.FactBridgeTerritoriesPipelineDeals
           (TerritoryTreeKey, PipelineDealKey, TerritoryTreeId, PipelineDealId)
SELECT 	
	k.[generatedkey] AS [TerritoryTreeKey]
	,k.generatedkey2 AS [PipelineDealKey]
	,TerritoryTreeId
	,PipelineDealId
FROM 
(
	SELECT 
		ts.TerritoryTreeId
		,pd.Id AS PipelineDealId
	FROM [$(MediaDMStaging)].[dbo].[TerritorySelection] ts
	INNER JOIN [$(MediaDMStaging)].[dbo].[PipelineDeal] pd ON ts.TerritorySelectionId = pd.TerritorySelectionId
	WHERE ts.StatusId = 1
) AS tt
CROSS APPLY [dbo].[ufn_GenerateKey](TerritoryTreeId,PipelineDealId) as k

RETURN 0