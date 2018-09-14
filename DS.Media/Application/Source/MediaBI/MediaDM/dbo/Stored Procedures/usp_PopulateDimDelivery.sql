CREATE PROCEDURE [dbo].[usp_PopulateDimDelivery]
AS
	
DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimDelivery') IS NOT NULL DROP TABLE #DimDelivery

SELECT * INTO #DimDelivery FROM dbo.DimDelivery WHERE 1 = 2;

INSERT INTO #DimDelivery
           ([DeliveryKey]
           ,[Property]
           ,[Label]
           ,[BroadcastType]
           ,[GeneralType]
           ,[Version]
           ,[FeedCoordination]
           ,[ShipDate]
           ,[VideoStandard]
           ,[AspectRation]
           ,[ShippedDate]
           ,[AWBNumber]
           ,[IsOnHold]
           ,[Language]
           ,[TapeFormat]
           ,[AudioFormat]
           ,[NumberOfTapes]
		   ,[HashKey]
		   ,[DeletedOn])
SELECT [DeliveryKey]
      ,[Property]
      ,[Label]
      ,[BroadcastType]
      ,[GeneralType]
      ,[Version]
      ,[FeedCoordination]
      ,[ShipDate]
      ,[VideoStandard]
      ,[AspectRation]
      ,[ShippedDate]
      ,[AWBNumber]
      ,[IsOnHold]
      ,[Language]
      ,[TapeFormat]
      ,[AudioFormat]
      ,[NumberOfTapes]
      ,dbo.ufn_GetHashDimDelivery([DeliveryKey], [Property], [Label], [BroadcastType], [GeneralType], [Version], [FeedCoordination], [ShipDate], [VideoStandard], [AspectRation]
      ,[ShippedDate] ,[AWBNumber], [IsOnHold], [Language], [TapeFormat], [AudioFormat], [NumberOfTapes]) AS HashKey
      ,NULL AS DeletedOn

FROM (
SELECT
	dbo.CreateKeyFromSourceID(odd.Id) AS DeliveryKey,
	COALESCE(pr.[Description], 'N/A') AS Property,
	ISNULL(ppr.[Description], pr.[Description]) AS Label,
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.DeliveryType_lu WHERE Id = odd.DeliveryTypeId), 'N/A') AS BroadcastType,
	COALESCE(pt.[Description], 'N/A') AS GeneralType,
	COALESCE(v.[Description], 'N/A') AS [Version],
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.FeedCoordination_lu WHERE Id = odd.FeedCoordinationId), 'N/A') AS FeedCoordination, 
--	COALESCE(odd.ShipDate, '1900-01-01') AS [ShipDate],
    odd.ShipDate AS [ShipDate], 
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.VideoStandard_lu v WHERE v.Id = odd.VideoStandardId), 'N/A') AS VideoStandard,
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.AspectRatio_lu WHERE Id = odd.AspectRatioId), 'N/A') AS AspectRation,
--	COALESCE(odd.ShippedDate, '1900-01-01') AS [ShippedDate],
	odd.ShippedDate AS [ShippedDate],
	COALESCE(odd.AWBNumber, 'N/A') AS [AWBNumber],
	CASE WHEN odd.IsOnHold = 1 THEN 'Yes' ELSE 'No' END AS IsOnHold,
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.Language_lu WHERE Id = odd.LanguageId), 'N/A') AS [Language],
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.TapeFormat_lu WHERE Id = odd.TapeFormatId), 'N/A') AS TapeFormat,
	COALESCE((SELECT [Description] FROM [$(MediaDMStaging)].dbo.AudioFormat_lu WHERE Id = odd.AudioFormatId), 'N/A') AS AudioFormat,
	COALESCE(odd.NumberOfTapes, -1) AS NumberOfTapes
FROM	
	[$(MediaDMStaging)].[dbo].OrderDetailDelivery odd
	INNER JOIN [$(MediaDMStaging)].[dbo].Product pr ON pr.Id = odd.ProductId
	LEFT JOIN [$(MediaDMStaging)].[dbo].Product ppr ON ppr.Id = pr.ParentId
	LEFT JOIN [$(MediaDMStaging)].[dbo].ProductType_lu pt ON odd.ProductTypeId = pt.Id
	LEFT JOIN [$(MediaDMStaging)].[dbo].[Version] v ON v.Id = odd.VersionId
WHERE odd.StatusId = 1

UNION ALL

SELECT
	dbo.CreateKeyFromSourceID(-1) AS DeliveryKey,
	'N/A' AS Property,
	'N/A' AS Label,
	'N/A' AS BroadcastType,
	'N/A' AS GeneralType,
	'N/A' AS [Version],
	'N/A' AS FeedCoordination, 
	NULL AS ShipDate,
	'N/A' AS VideoStandard,
	'N/A' AS AspectRation,
	NULL AS ShippedDate,
	'N/A' AS AWBNumber,
	'N/A' AS IsOnHold,
	'N/A' AS [Language],
	'N/A' AS TapeFormat,
	'N/A' AS AudioFormat,
	-1 AS NumberOfTapes
) tt
;

MERGE 
    dbo.DimDelivery t
USING 
    #DimDelivery s ON (t.DeliveryKey = s.DeliveryKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey OR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.DeliveryKey = s.DeliveryKey
		,t.Property = s.Property
		,t.Label = s.Label
		,t.BroadcastType = s.BroadcastType
        ,t.GeneralType = s.GeneralType
        ,t.Version = s.Version
        ,t.FeedCoordination = s.FeedCoordination
        ,t.ShipDate = s.ShipDate
        ,t.VideoStandard = s.VideoStandard
        ,t.AspectRation = s.AspectRation
        ,t.ShippedDate = s.ShippedDate
        ,t.AWBNumber = s.AWBNumber
        ,t.IsOnHold = s.IsOnHold
        ,t.Language = s.Language
        ,t.TapeFormat = s.TapeFormat
        ,t.AudioFormat = s.AudioFormat
        ,t.NumberOfTapes = s.NumberOfTapes
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([DeliveryKey], [Property], [Label], [BroadcastType], [GeneralType], [Version], [FeedCoordination], [ShipDate], [VideoStandard], [AspectRation]
      ,[ShippedDate] ,[AWBNumber], [IsOnHold], [Language], [TapeFormat], [AudioFormat], [NumberOfTapes], HashKey)
    VALUES (s.[DeliveryKey], s.[Property], s.[Label], s.[BroadcastType], s.[GeneralType], s.[Version], s.[FeedCoordination], s.[ShipDate], s.[VideoStandard], s.[AspectRation]
      ,s.[ShippedDate] ,s.[AWBNumber], s.[IsOnHold], s.[Language], s.[TapeFormat], s.[AudioFormat], s.[NumberOfTapes], s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;

RETURN 0
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimDelivery] TO [DataServices]
    AS [dbo];
GO

