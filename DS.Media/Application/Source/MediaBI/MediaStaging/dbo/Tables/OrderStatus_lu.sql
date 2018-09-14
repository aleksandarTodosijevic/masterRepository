CREATE TABLE [dbo].[OrderStatus_lu] (
    [Id]          INT          NOT NULL,
    [Description] VARCHAR (30) NOT NULL,
    [SortOrder]   INT          NOT NULL,
    [StatusType]  CHAR (1)     NOT NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    CONSTRAINT [PK_OrderStatus_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);



