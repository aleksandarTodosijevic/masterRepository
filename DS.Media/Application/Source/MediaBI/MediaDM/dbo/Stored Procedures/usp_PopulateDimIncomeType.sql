CREATE PROCEDURE [dbo].[usp_PopulateDimIncomeType]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimIncomeType') IS NOT NULL DROP TABLE #DimIncomeType

SELECT * INTO #DimIncomeType FROM dbo.DimIncomeType WHERE 1 = 2;


INSERT INTO #DimIncomeType (IncomeTypeKey, SourceIncomeTypeId, SalesCategory, FeeType, FeeDescription, HashKey, DeletedOn)
SELECT
	 IncomeTypeKey
	,SourceIncomeTypeId
	,SalesCategory
	,FeeType 
	,FeeDescription
    ,dbo.ufn_GetHashDimIncomeType(IncomeTypeKey, SourceIncomeTypeId, SalesCategory, FeeType, FeeDescription) AS HashKey
    ,NULL AS DeletedOn
FROM(
SELECT dbo.CreateKeyFromSourceID(it.Id) as IncomeTypeKey
, CASE f.FeeTypeId WHEN 1 THEN 'Rights' WHEN 2 THEN 'Technical' END as FeeType
, it.Id as SourceIncomeTypeId, sc.Description as SalesCategory, f.Description as FeeDescription
FROM [$(MediaDMStaging)].dbo.IncomeType_lu it
JOIN [$(MediaDMStaging)].dbo.SalesCategory_lu sc ON sc.Id = it.SalesCategoryId
JOIN [$(MediaDMStaging)].dbo.Fee_lu f On f.Id = it.FeeId
) tt
;


MERGE 
    dbo.DimIncomeType t
USING 
    #DimIncomeType s ON (t.IncomeTypeKey = s.IncomeTypeKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey oR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.IncomeTypeKey = s.IncomeTypeKey
	    ,t.SourceIncomeTypeId = s.SourceIncomeTypeId
	    ,t.SalesCategory = s.SalesCategory
		,t.FeeType = s.FeeType
		,t.FeeDescription = s.FeeDescription
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (IncomeTypeKey, SourceIncomeTypeId, SalesCategory, FeeType, FeeDescription, HashKey)
    VALUES (s.IncomeTypeKey, s.SourceIncomeTypeId, s.SalesCategory, s.FeeType, s.FeeDescription, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;



RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimIncomeType] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimIncomeType] TO [DataServices]
    AS [dbo];
GO
