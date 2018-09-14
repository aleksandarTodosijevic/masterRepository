CREATE TABLE [dbo].[UserCustomerFavorite] (
    [Id]          INT      IDENTITY (1, 1) NOT NULL,
    [UserId]      INT      NOT NULL,
    [CustomerId]  INT      NOT NULL,
    [StatusId]    INT      NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [CreatedBy]   INT      NOT NULL,
    [UpdatedDate] DATETIME NULL,
    [UpdatedBy]   INT      NULL,
    CONSTRAINT [PK_UserCustomerFavorite] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);



