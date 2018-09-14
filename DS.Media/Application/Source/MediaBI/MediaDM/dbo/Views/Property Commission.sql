

CREATE VIEW [dbo].[Property Commission]
AS
SELECT 
	[PropertyKey] AS [Property Key]
	,[PropertyKey] AS [Property Commission Key]
    ,[SourceProductId] AS [Source Product Id]
     
  FROM [dbo].[DimProperty];
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Property Commission] TO [DataServices]
    AS [dbo];

