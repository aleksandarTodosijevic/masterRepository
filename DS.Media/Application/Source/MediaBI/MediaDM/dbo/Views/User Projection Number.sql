

CREATE VIEW [dbo].[User Projection Number]
	AS 
SELECT 
	 [UserProjectionNumberKey] AS [User Projection Number Key]
    ,[ProjectionNumberNo] AS [Projection Number No]
    ,[ProjectionNumber] AS [Projection Number]
  FROM [DimUserProjectionNumber]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Projection Number] TO [DataServices]
    AS [dbo];

