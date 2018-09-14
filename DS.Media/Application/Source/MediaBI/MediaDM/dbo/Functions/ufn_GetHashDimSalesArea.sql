Create FUNCTION [dbo].[ufn_GetHashDimSalesArea]
(
	 @SalesAreaKey BIGINT
	,@SourceSalesAreaId INT
	,@SalesRegion VARCHAR(50)
	,@SalesArea VARCHAR(50)
	,@AreaNumber VARCHAR(4)
	,@ExecResponsible VARCHAR(101)
	,@SalesAreaStatus VARCHAR(20)
	,@EntertainmentSalesExec NVARCHAR(100)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @SalesAreaKey AS SalesAreaKey
	,@SourceSalesAreaId AS SourceSalesAreaId
	,@SalesRegion AS SalesRegion
	,@SalesArea AS SalesArea
	,@AreaNumber AS AreaNumber
	,@ExecResponsible AS ExecResponsible
	,@SalesAreaStatus AS SalesAreaStatus
	,@EntertainmentSalesExec AS EntertainmentSalesExec
	FOR XML RAW('r')))
END