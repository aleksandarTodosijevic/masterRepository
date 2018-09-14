CREATE VIEW [dbo].[Property Rights]
AS
SELECT [PropertyRightsKey] AS [Property Rights Key]
      ,[RightsSelection] AS [Rights Selection]
      ,[TerritorySelection] AS [Territory Selection]
      ,[LanguageSelection] AS [Language Selection]
	  ,[LicenseStartDate] AS [License Start Date]
	  ,[LicenseEndDate] AS [License End Date]
	  ,[InPerpetuity] AS [In Perpetuity]
  FROM [dbo].[DimPropertyRights]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Property Rights] TO [DataServices]
    AS [dbo];

