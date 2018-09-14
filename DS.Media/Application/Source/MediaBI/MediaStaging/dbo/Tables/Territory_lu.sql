CREATE TABLE [dbo].[Territory_lu] (
    [Id]             INT           NOT NULL,
    [Description]    VARCHAR (50)  NOT NULL,
    [CountryCode]    VARCHAR (3)   NULL,
    [ProjectionCode] VARCHAR (3)   NULL,
    [MapCode]        VARCHAR (3)   NULL,
    [Comment]        VARCHAR (255) NULL,
    [IsTerritory]    BIT           NOT NULL,
    [PostalCodeRule] BIT           NOT NULL,
    [PostalCodeMask] VARCHAR (100) NULL,
    [StatusId]       INT           NOT NULL,
    [CreatedDate]    DATETIME      NOT NULL,
    [CreatedBy]      INT           NOT NULL,
    [UpdatedDate]    DATETIME      NULL,
    [UpdatedBy]      INT           NULL,
    CONSTRAINT [PK_Territory_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



