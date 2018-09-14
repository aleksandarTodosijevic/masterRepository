CREATE TABLE [dbo].[DimProjectionAnticipated] (
    [ProjectionAnticipatedKey]   BIGINT           NOT NULL,
    [CreatedDateOfAnticipated]   DATETIME         NOT NULL,
    [AnticipatedAmountCreatedBy] VARCHAR (102)    NULL,
    [UpdatedDateOfAnticipated]   DATETIME         NULL,
    [AnticipatedAmountUpdatedBy] VARCHAR (102)    NULL,
	[IsAppearInTotal]			 CHAR(3)		  NULL,
    [HashKey]                    VARBINARY (8000) NOT NULL,
    [DeletedOn]                  DATETIME         NULL,
    CONSTRAINT [PK_DimProjectionAnticipated] PRIMARY KEY CLUSTERED ([ProjectionAnticipatedKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimProjectionAnticipated] TO [DataServices]
    AS [dbo];

