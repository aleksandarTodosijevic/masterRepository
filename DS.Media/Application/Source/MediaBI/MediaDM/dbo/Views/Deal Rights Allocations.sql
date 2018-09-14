

CREATE VIEW [dbo].[Deal Rights Allocations]
AS
SELECT        DealRightsId AS DealrightsKey, 
	AllocationsKey 
FROM            dbo.FactDealRightsAllocations