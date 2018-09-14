CREATE TABLE [dbo].[Client] (
    [Id]                 INT           NOT NULL,
    [ClientNo]           INT           NULL,
    [ClientName]         VARCHAR (80)  NOT NULL,
    [ClientName2]        VARCHAR (80)  NULL,
    [ShortName]          VARCHAR (20)  NOT NULL,
    [ClientFullName]     VARCHAR (160) NOT NULL,
    [SAPVendorNo]        INT           NULL,
    [LegalReferenceNo]   INT           NULL,
    [IsProjectionClient] BIT           NOT NULL,
    [IsIMGClient]        BIT           NOT NULL,
    [StatusId]           INT           NOT NULL,
    [CreatedDate]        DATETIME      NOT NULL,
    [CreatedBy]          INT           NOT NULL,
    [UpdatedDate]        DATETIME      NULL,
    [UpdatedBy]          INT           NULL,
    CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED ([Id] ASC)
);



