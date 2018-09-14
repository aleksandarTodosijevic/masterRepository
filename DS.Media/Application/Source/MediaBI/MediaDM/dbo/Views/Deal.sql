CREATE VIEW [dbo].[Deal]
AS SELECT
	d.DealKey AS [Deal Key]
    ,d.DealNo as [Deal No]
    ,d.DealStatus as [Deal Status]
    ,d.SalesCategory as [Sales Category]
	,CASE WHEN d.FirstProcessedDate < GETDATE() THEN 'Yes' ELSE 'No' END [Deal Was Processed]
	,d.FirstProcessedDate AS [First Processed Date]
	,d.LastProcessedDate AS [Last Processed Date]
FROM dbo.DimDeal d
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal] TO [DataServices]
    AS [dbo];

