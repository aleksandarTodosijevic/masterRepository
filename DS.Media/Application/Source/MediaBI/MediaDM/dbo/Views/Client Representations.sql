
CREATE VIEW [dbo].[Client Representations]
AS
SELECT [PropertyKey] AS [Property Key]
      ,[ClientKey] AS [Client Key]
	  ,[UltimateOwnerKey] AS [Ultimate Owner Key]
      ,[IsUltimateOwner] AS [IsUltimate Owner]
  FROM [dbo].[FactClientRepresentations]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Client Representations] TO [DataServices]
    AS [dbo];

