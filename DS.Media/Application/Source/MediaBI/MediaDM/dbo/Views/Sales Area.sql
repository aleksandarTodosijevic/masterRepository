CREATE VIEW [dbo].[Sales Area]
AS SELECT
	SalesAreaKey
	,SalesRegion AS [Sales Region]
	,SalesArea AS [Sales Area]
	,AreaNumber AS [Area Number]
	,ExecResponsible AS [Exec Responsible] 
	,[EntertainmentSalesExec] AS [Entertainment Sales Exec]
	,SalesAreaStatus AS [Sales Area Status]
FROM dbo.DimSalesArea;
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sales Area] TO [DataServices]
    AS [dbo];

