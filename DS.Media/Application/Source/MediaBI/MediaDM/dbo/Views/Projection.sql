CREATE VIEW [dbo].Projection
AS
SELECT [ProjectionKey] AS [ProjectionKey]
      ,[ProjectionNo] AS [Projection No (Projection)]
      ,[ProjectionName] AS [Projection Name (Projection)]
	  ,[ProjectionNoT] AS [Projection No Technical (Projection)]
      ,[ProjectionNameT] AS [Projection Name Technical (Projection)]
	  ,[SubjectCategory] AS [Subject Category]
  FROM [dbo].[DimProjection]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Projection] TO [DataServices]
    AS [dbo];

