CREATE TABLE [dbo].[DimProjectionYear] (
    [ProjectionYear] CHAR (4) NOT NULL,
    CONSTRAINT [PK_DimProjectionYear] PRIMARY KEY CLUSTERED ([ProjectionYear] ASC)
);






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimProjectionYear] TO [DataServices]
    AS [dbo];

