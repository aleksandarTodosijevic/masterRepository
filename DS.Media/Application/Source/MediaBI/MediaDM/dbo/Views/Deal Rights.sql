CREATE VIEW [dbo].[Deal Rights]
AS
SELECT [DealRightsKey] AS [Deal Rights Key]
      ,[DealRightsDescription] AS [Deal Rights Description]
	  ,[Exclusive] AS [Exclusive]
	  ,[TerritoryDescription] AS [Territory Description]
	  ,[LanguageDescription] AS [Language Description]
	  ,[LicenseStart] AS [License Start]
	  ,[LicenseEnd] AS [License End]
	  ,[NumberOfTransmissions] AS [Number of Transmissions]
	  ,[NumberOfTransmissionsName] AS [Number Of Transmissions Name]
	  ,[InPerpetuity] AS [In Perpetuity]
	  ,[LicenseDuration] AS [License Duration]
  FROM [dbo].[DimDealRights]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal Rights] TO [DataServices]
    AS [dbo];

