

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[Contract]
AS
SELECT [ContractKey] AS [Contract Key]
      ,[ContractDescription] AS [Contract Description]
      ,[AgreementType] AS [Agreement Type]
      ,[AgreementBy] AS [Agreement By]
      ,[ContractType] AS [Contract Type]
      ,[LicensorParty] AS [Licensor Party]
      ,[LegalOnline] AS  [Legal Online]
	  ,[LegalContractStatus] AS [LOL Status]
      ,[Licensor] AS [Licensor]
      ,[ContractText] AS [Contract Text]
	  ,ContractInstructions AS [Contract Instructions]
	  ,IssueSite AS [Issue Site (Contract)]
	  ,City AS [City (Contract)]
	  ,Region AS [Region (Contract)]
	  ,Country AS [Country (Contract)]
	  ,LegalOnlineContact AS [Legal Online Contact]
	  ,IssueSiteId AS [Issue Site Id (Contract)]
  FROM [dbo].[DimContract]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Contract] TO [DataServices]
    AS [dbo];

