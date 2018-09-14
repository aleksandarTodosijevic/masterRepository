CREATE VIEW [dbo].[Rights]
AS
SELECT
	DealKey AS [Deal Key]
	,CustomerContactKey AS [Customer Contact Key]
	,[LicenseStartDateKey] AS [License Start Date Key]
    ,[LicenseEndDateKey] AS [License End Date Key]
	,CONVERT(date, convert(varchar(10), [LicenseStartDateKey])) AS [License Start Date]
	,CONVERT(date, convert(varchar(10), [LicenseEndDateKey])) AS [License End Date]
    ,[PropertyKey] AS [Property Key]
	,[DealPropertyKey] AS [Deal Property Key]
    ,[DealRightsKey] AS [Deal Rights Key]
    ,[PropertyRightsKey] AS [Property Rights Key]
	,[DealCreatedByKey] AS [Deal Created By Key]
    ,[DealCreatedOnDateKey] AS [Deal Created On Date Key]
    ,[DealUpdatedByKey] AS [Deal Updated By Key]
    ,[DealUpdatedOnDateKey] AS [Deal Updated On Date Key]
	,[ProjectionKey] AS [Projection Key]
	,EntertainmentShippedDateKey AS [Entertainment Shipped Date Key]
	,RecognitionDateKey AS [Recognition Date Key]
FROM [dbo].[FactRights]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Rights] TO [DataServices]
    AS [dbo];

