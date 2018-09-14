CREATE VIEW [dbo].[Deliveries]
	AS 
SELECT
	[DeliveryKey] AS [Delivery Key]
    ,[PropertyKey] AS [Property Key]
    ,[ProjectionKey] AS [Projection Key]
	,[DealKey] AS [Deal Key]
FROM [dbo].[FactDeliveries]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deliveries] TO [DataServices]
    AS [dbo];

