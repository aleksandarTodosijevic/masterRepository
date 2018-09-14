
CREATE VIEW [dbo].[Property Version]
AS
SELECT [VersionKey] AS [Version Key]
      ,[PropertyKey] AS [Property Key]
	  ,[BroadcastType] AS [Broadcast Type]
	  ,[VersionName] AS [Version Name]
	  ,[AvailabilityDate] AS [Availability Date]
  FROM [dbo].[DimPropertyVersion]