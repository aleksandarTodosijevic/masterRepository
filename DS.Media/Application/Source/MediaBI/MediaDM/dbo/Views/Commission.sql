CREATE VIEW [dbo].[Commission]
	AS 
SELECT [PropertyKey] AS [Property Key]
	  ,[SalesCategoryMDS] AS [Sales Category (MDS)]
      ,[AbbreviationMDS] AS [Abbreviation]
      ,[CommissionMDS] AS [Commission]
      ,[CommissionNumMDS] AS [Commission INT]
	  ,[CommentMDS] AS [Comment] 
  FROM [dbo].[DimProperty];

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Commission] TO [DataServices]
    AS [dbo];

