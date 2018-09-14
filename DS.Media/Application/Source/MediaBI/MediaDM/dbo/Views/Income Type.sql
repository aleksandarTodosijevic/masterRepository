CREATE VIEW [dbo].[Income Type]
AS SELECT 
 [IncomeTypeKey]
,[SourceIncomeTypeId]
,[SalesCategory] as [Sales Category]
,[FeeType] as [Fee Type]
,[FeeDescription] as [Fee Description]
  FROM [dbo].[DimIncomeType]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Income Type] TO [DataServices]
    AS [dbo];

