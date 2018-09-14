CREATE TABLE [dbo].[FactUserProjectionNumbers] (
    [UserProjectionNumberKey]  BIGINT           NULL,
    [UserKey]                  BIGINT           NULL,
    [CountOfProjectionNumbers] INT              NOT NULL,
    [HashKey]                  VARBINARY (8000) NULL,
    [DeletedOn]                DATETIME         NULL,
    CONSTRAINT [FK_FactUserProjectionNumber_DimUser] FOREIGN KEY ([UserKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactUserProjectionNumber_DimUserProjectionNumber] FOREIGN KEY ([UserProjectionNumberKey]) REFERENCES [dbo].[DimUserProjectionNumber] ([UserProjectionNumberKey])
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactUserProjectionNumbers] TO [DataServices]
    AS [dbo];

