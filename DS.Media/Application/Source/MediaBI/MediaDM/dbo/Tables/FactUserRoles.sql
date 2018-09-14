CREATE TABLE [dbo].[FactUserRoles] (
    [UserKey]      BIGINT           NOT NULL,
    [RoleKey]      BIGINT           NOT NULL,
    [CountOfRoles] INT              NOT NULL,
    [HashKey]      VARBINARY (8000) NULL,
    [DeletedOn]    DATETIME         NULL,
    CONSTRAINT [FK_FactUserRoles_DimRole] FOREIGN KEY ([RoleKey]) REFERENCES [dbo].[DimRole] ([RoleKey]),
    CONSTRAINT [FK_FactUserRoles_DimUser] FOREIGN KEY ([UserKey]) REFERENCES [dbo].[DimUser] ([UserKey])
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactUserRoles] TO [DataServices]
    AS [dbo];

