

CREATE VIEW [dbo].[Client]
AS
SELECT [ClientKey] AS [Client Key]
      ,[ClientNo] AS [Client No]
      ,[ClientNoInt] AS [Client No Int]
      ,[ClientName] AS [Client Name]
      ,[ClientName2] AS [Client Name2]
      ,[ClientFullName] AS [Client Full Name]
      ,[ClientAddress] AS [Client Address]
	  ,[ClientCountry] AS [Client Country]
      ,[IsIMGClient] AS [Is IMG Client]
      ,[IsProjectionClient] AS [Is Projection Client]
  FROM [dbo].[DimClient]
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Client] TO [DataServices]
    AS [dbo];

