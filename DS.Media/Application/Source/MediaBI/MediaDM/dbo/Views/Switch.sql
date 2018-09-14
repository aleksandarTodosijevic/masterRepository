CREATE VIEW [dbo].[Switch]
	AS
SELECT dbo.CreateKeyFromSourceID(-1) AS [Property Key]
     , fsa.SalesAreaKey AS [Sales Area Key]
	 , dbo.CreateKeyFromSourceID(-1) AS [Projection Key]
	 , du.DomainName AS [Domain Name]
	 , 'Sales Area' AS [Switch Security]
	 , 'N/A' AS [Switch Projection Type]
  FROM [dbo].[Security_FactSalesAreas] fsa
 INNER JOIN [dbo].[Security_DimUser] du ON fsa.SecurityUserKey = du.SecurityUserKey 
 UNION ALL
SELECT fp.PropertyKey AS [Property Key]
     , dbo.CreateKeyFromSourceID(-1) AS [Sales Area Key]
	 , dbo.CreateKeyFromSourceID(-1) AS [Projection Key]
	 , du.DomainName AS [Domain Name]
	 , 'Area of Bussiness' AS [Switch Security]
	 , 'N/A' AS [Switch Projection Type]
  FROM [dbo].[Security_FactProperties] fp
 INNER JOIN [dbo].[Security_DimUser] du ON fp.SecurityUserKey = du.SecurityUserKey 
 UNION ALL
SELECT dbo.CreateKeyFromSourceID(-1) AS [Property Key]
     , dbo.CreateKeyFromSourceID(-1) AS [Sales Area Key]
	 , fpr.ProjectionKey AS [Projection Key]
	 , du.DomainName AS [Domain Name]
	 , 'Projection Numbers' AS [Switch Security]
	 , 'N/A' AS [Switch Projection Type]
  FROM [dbo].[Security_FactProjections] fpr
 INNER JOIN [dbo].[Security_DimUser] du ON fpr.SecurityUserKey = du.SecurityUserKey 
 UNION ALL
SELECT dbo.CreateKeyFromSourceID(-1) AS [Property Key]
     , dbo.CreateKeyFromSourceID(-1) AS [Sales Area Key]
	 , dbo.CreateKeyFromSourceID(-1) AS [Projection Key]
	 , 'N/A' AS [Domain Name]
	 , 'N/A' AS [Switch Security]
	 , 'Actual Amount USD (Projections)' AS [Switch Projection Type]
 UNION ALL
SELECT dbo.CreateKeyFromSourceID(-1) AS [Property Key]
     , dbo.CreateKeyFromSourceID(-1) AS [Sales Area Key]
	 , dbo.CreateKeyFromSourceID(-1) AS [Projection Key]
	 , 'N/A' AS [Domain Name]
	 , 'N/A' AS [Switch Security]
	 , 'Anticipated Amount USD' AS [Switch Projection Type]
 UNION ALL
SELECT dbo.CreateKeyFromSourceID(-1) AS [Property Key]
     , dbo.CreateKeyFromSourceID(-1) AS [Sales Area Key]
	 , dbo.CreateKeyFromSourceID(-1) AS [Projection Key]
	 , 'N/A' AS [Domain Name]
	 , 'N/A' AS [Switch Security]
	 , 'Projected Amount USD' AS [Switch Projection Type]
 UNION ALL
SELECT dbo.CreateKeyFromSourceID(-1) AS [Property Key]
     , dbo.CreateKeyFromSourceID(-1) AS [Sales Area Key]
	 , dbo.CreateKeyFromSourceID(-1) AS [Projection Key]
	 , du.DomainName AS [Domain Name]
	 , 'All - Items' AS [Switch Security]
	 , 'N/A' AS [Switch Projection Type]
  FROM [dbo].[Security_DimUser] du

GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Switch] TO [DataServices]
    AS [dbo];