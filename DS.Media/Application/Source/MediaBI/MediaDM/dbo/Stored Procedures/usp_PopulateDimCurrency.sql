CREATE PROCEDURE [dbo].[usp_PopulateDimCurrency]
AS
SET NOCOUNT ON;


DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimCurrency') IS NOT NULL DROP TABLE #DimCurrency
	
SELECT * INTO #DimCurrency FROM dbo.DimCurrency WHERE 1 = 2;

INSERT INTO #DimCurrency
SELECT 
	 CurrencyKey
	,SourceCurrencyId
	,CurrencyCode
	,CurrencyDescription
    ,dbo.ufn_GetHashDimCurrency(CurrencyKey, SourceCurrencyId, CurrencyCode, CurrencyDescription) AS HashKey
    ,NULL AS DeletedOn
FROM (
SELECT dbo.CreateKeyFromSourceID(Id) as CurrencyKey
, Id as SourceCurrencyId, Code as CurrencyCode, Description as CurrencyDescription
FROM [$(MediaDMStaging)].dbo.Currency_lu
) tt


MERGE 
    dbo.DimCurrency t
USING 
    #DimCurrency s ON (t.CurrencyKey = s.CurrencyKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
	 t.SourceCurrencyId = s.SourceCurrencyId
	,t.CurrencyCode = s.CurrencyCode
	,t.CurrencyDescription = s.CurrencyDescription
	,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CurrencyKey, SourceCurrencyId, CurrencyCode, CurrencyDescription, HashKey)
    VALUES (s.CurrencyKey, s.SourceCurrencyId, s.CurrencyCode, s.CurrencyDescription, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;




RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimCurrency] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimCurrency] TO [DataServices]
    AS [dbo];
GO
