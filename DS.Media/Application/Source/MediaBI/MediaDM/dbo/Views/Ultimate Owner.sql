CREATE VIEW [dbo].[Ultimate Owner]
AS
SELECT [ClientKey] AS [Ultimate Owner Key]
      ,[ClientNo] AS [Ultimate Owner No]
      ,[ClientNoInt] AS [Ultimate Owner No Int]
      ,[ClientName] AS [Ultimate Owner Name]
      ,[ClientName2] AS [Ultimate Owner Name2]
      ,[ClientFullName] AS [Ultimate Owner Full Name]
      ,[ClientAddress] AS [Ultimate Owner Address]
	  ,[ClientCountry] AS [Ultimate Owner Country]
      ,[IsIMGClient] AS [Is IMG Client (Ultimate Owner)]
      ,[IsProjectionClient] AS [Is Projection Client (Ultimate Owner)]
  FROM [dbo].[DimClient]
 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Ultimate Owner] TO [DataServices]
    AS [dbo];

