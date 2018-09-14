CREATE VIEW [dbo].[Delivery]
	AS 
SELECT [DeliveryKey] AS [Delivery Key]
      ,[Property] AS [Shipped Program]
      ,[Label] As [Label]
      ,[BroadcastType] AS [Broadcast Type]
      ,[GeneralType] AS [General Type]
      ,[Version] AS [Version]
      ,[FeedCoordination] AS [Ship./Feed Coordination Site]
      ,[ShipDate] AS [Ship Date]
      ,[VideoStandard] AS [Standard]
      ,[AspectRation] AS [Aspect Ratio]
      ,[ShippedDate] AS [Shipped Date]
      ,[AWBNumber] AS [AWB Number]
      ,[IsOnHold] AS [Is On Hold]
      ,[Language] AS [Language]
      ,[TapeFormat] AS [Format]
      ,[AudioFormat] AS [Audio Format]
  FROM [dbo].[DimDelivery]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delivery] TO [DataServices]
    AS [dbo];

