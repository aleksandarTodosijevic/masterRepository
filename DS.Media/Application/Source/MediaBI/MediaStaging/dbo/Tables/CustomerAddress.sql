CREATE TABLE [dbo].[CustomerAddress] (
    [Id]                   INT          NOT NULL,
    [CustomerId]           INT          NOT NULL,
    [Line1]                VARCHAR (50) NOT NULL,
    [Line2]                VARCHAR (50) NOT NULL,
    [Line3]                VARCHAR (50) NULL,
    [TerritoryRegionId]    INT          NULL,
    [TerritoryId]          INT          NOT NULL,
    [Line6]                VARCHAR (50) NULL,
    [CategoryBitSum]       INT          NOT NULL,
    [Valid]                BIT          NOT NULL,
    [PayerNumber]          VARCHAR (10) NULL,
    [IsNewBAPIMappingUsed] BIT          NOT NULL,
    [StatusId]             INT          NOT NULL,
    [CreatedDate]          DATETIME     NOT NULL,
    [CreatedBy]            INT          NOT NULL,
    [UpdatedDate]          DATETIME     NULL,
    [UpdatedBy]            INT          NULL,
    CONSTRAINT [PK_CustomerAddress] PRIMARY KEY CLUSTERED ([Id] ASC)
);


