CREATE TABLE [dbo].[DimDelivery] (
    [DeliveryKey]      BIGINT           NOT NULL,
    [Property]         VARCHAR (50)     NOT NULL,
    [Label]            VARCHAR (50)     NOT NULL,
    [BroadcastType]    VARCHAR (50)     NULL,
    [GeneralType]      VARCHAR (50)     NULL,
    [Version]          VARCHAR (70)     NOT NULL,
    [FeedCoordination] VARCHAR (50)     NULL,
    [ShipDate]         DATETIME         NULL,
    [VideoStandard]    VARCHAR (50)     NULL,
    [AspectRation]     VARCHAR (50)     NULL,
    [ShippedDate]      DATETIME         NULL,
    [AWBNumber]        VARCHAR (20)     NULL,
    [IsOnHold]         VARCHAR (3)      NOT NULL,
    [Language]         VARCHAR (50)     NULL,
    [TapeFormat]       VARCHAR (50)     NULL,
    [AudioFormat]      VARCHAR (50)     NULL,
    [NumberOfTapes]    INT              NULL,
    [HashKey]          VARBINARY (8000) NOT NULL,
    [DeletedOn]        DATETIME         NULL,
    CONSTRAINT [PK_DimDelivery] PRIMARY KEY CLUSTERED ([DeliveryKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimDelivery] TO [DataServices]
    AS [dbo];

