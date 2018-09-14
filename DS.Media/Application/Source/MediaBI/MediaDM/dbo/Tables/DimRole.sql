CREATE TABLE [dbo].[DimRole] (
    [RoleKey]       BIGINT           NOT NULL,
    [NameOfRole]    VARCHAR (50)     NOT NULL,
    [CommentOfRole] VARCHAR (255)    NOT NULL,
    [HashKey]       VARBINARY (8000) NOT NULL,
    [DeletedOn]     DATETIME         NULL,
    CONSTRAINT [PK_DimRole] PRIMARY KEY CLUSTERED ([RoleKey] ASC)
);












GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimRole] TO [DataServices]
    AS [dbo];

