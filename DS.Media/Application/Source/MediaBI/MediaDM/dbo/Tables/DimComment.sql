CREATE TABLE [dbo].[DimComment] (
    [CommentKey]      BIGINT           NOT NULL,
    [SourceCommentId] VARCHAR (11)     NOT NULL,
    [Description]     VARCHAR (3000)   NOT NULL,
    [Regarding]       INT              NOT NULL,
    [SourceEntity]    VARCHAR (10)     NOT NULL,
    [HashKey]         VARBINARY (8000) NOT NULL,
    [DeletedOn]       DATETIME         NULL,
    CONSTRAINT [PK_DimComment] PRIMARY KEY CLUSTERED ([CommentKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimComment] TO [DataServices]
    AS [dbo];

