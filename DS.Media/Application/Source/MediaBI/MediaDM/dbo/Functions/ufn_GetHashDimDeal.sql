Create FUNCTION [dbo].[ufn_GetHashDimDeal]
(
	 @DealKey BIGINT
	,@DealNo INT
	,@CustomerId INT
	,@SalesAreaId INT
	,@DealStatus VARCHAR(30)
	,@SalesCategory VARCHAR(50)
	,@FirstProcessedDate DATETIME
	,@LastProcessedDate DATETIME
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @DealKey AS DealKey 
	,@DealNo AS DealNo
	,@CustomerId AS CustomerId
	,@SalesAreaId AS SalesAreaId
	,@DealStatus AS DealStatus
	,@SalesCategory AS SalesCategory
	,@FirstProcessedDate AS FirstProcessedDate
	,@LastProcessedDate AS LastProcessedDate
	FOR XML RAW('r')))
END