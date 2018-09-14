CREATE TABLE [dbo].[Currency_lu] (
    [Id]          INT          NOT NULL,
    [Code]        CHAR (3)     NOT NULL,
    [POCCode]     VARCHAR (3)  NULL,
    [Description] VARCHAR (50) NOT NULL,
    [SortOrder]   SMALLINT     NOT NULL,
    [DisplayUnit] INT          NULL,
    [StatusId]    INT          NOT NULL,
    [CreatedDate] DATETIME     NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [UpdatedDate] DATETIME     NULL,
    [UpdatedBy]   INT          NULL,
    [Symbol]      VARCHAR (4)  NULL,
    CONSTRAINT [PK_Currency_lu] PRIMARY KEY CLUSTERED ([Id] ASC)
);





