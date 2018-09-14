

CREATE VIEW [dbo].[Rights Description]
AS
SELECT
	 RightsTreeKey AS [Rights Tree Key]
	,RightsTreeId AS [Rights Tree ID]
	,RightsTreeParentId AS [Rights Tree Parent ID]
	,RightsName AS [Rights Name]
	,HashKey AS [Hash Key]
	,DeletedOn AS [Deleted On]
FROM [dbo].[DimRights]