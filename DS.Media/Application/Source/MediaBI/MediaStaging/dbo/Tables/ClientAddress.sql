CREATE TABLE [dbo].[ClientAddress] (
    [Id]                INT          NOT NULL,
    [ClientId]          INT          NOT NULL,
    [Line1]             VARCHAR (50) NOT NULL,
    [Line2]             VARCHAR (50) NOT NULL,
    [Line3]             VARCHAR (50) NULL,
    [TerritoryRegionId] INT          NULL,
    [TerritoryId]       INT          NOT NULL,
    [Line6]             VARCHAR (50) NULL,
    [CategoryBitSum]    INT          NOT NULL,
    [Valid]             BIT          NOT NULL,
    [StatusId]          INT          NOT NULL,
    [CreatedDate]       DATETIME     NOT NULL,
    [CreatedBy]         INT          NOT NULL,
    [UpdatedDate]       DATETIME     NULL,
    [UpdatedBy]         INT          NULL,
    CONSTRAINT [PK_ClientAddress_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 95)
);



