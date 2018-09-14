CREATE PROCEDURE [dbo].[usp_PopulateFactBridgeRightsPropertyRights]
AS

TRUNCATE TABLE  [dbo].[FactBridgeRightsPropertyRights]



INSERT INTO [dbo].[FactBridgeRightsPropertyRights]
           ([RightsTreeKey]
           ,[PropertyRightsKey]
           ,[RightsTreeId]
           ,[DesignatedRightId])
SELECT 
	k.generatedkey AS RightsTreeKey
	,k.generatedkey2 AS PropertyRightsKey
	,RightsTreeId
	,DesignatedRightId
FROM
(
	SELECT 
		rs.RightsTreeId
		,dr.Id AS DesignatedRightId
	FROM [$(MediaDMStaging)].[dbo].[RightsSelection] rs
	INNER JOIN [$(MediaDMStaging)].[dbo].[DesignatedRight] dr ON rs.RightsSelectionId = dr.RightsSelectionId
	WHERE rs.StatusId = 1
) AS tt
CROSS APPLY [dbo].[ufn_GenerateKey](RightsTreeId,DesignatedRightId) k



RETURN 0