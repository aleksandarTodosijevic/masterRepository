CREATE TABLE [dbo].[FactComments] (
    [CommentKey]         BIGINT           NOT NULL,
    [CustomerContactKey] BIGINT           NOT NULL,
    [CreatedByKey]       BIGINT           NOT NULL,
    [CreatedOnDateKey]   INT              NOT NULL,
    [UpdatedByKey]       BIGINT           NOT NULL,
    [UpdatedOnDateKey]   INT              NOT NULL,
    [HashKey]            VARBINARY (8000) NULL,
    [DeletedOn]          DATETIME         NULL,
    CONSTRAINT [FK_FactComments_Comment] FOREIGN KEY ([CommentKey]) REFERENCES [dbo].[DimComment] ([CommentKey]),
    CONSTRAINT [FK_FactComments_CreatedBy] FOREIGN KEY ([CreatedByKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactComments_CreatedOnDate] FOREIGN KEY ([CreatedOnDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]),
    CONSTRAINT [FK_FactComments_CustomerContact] FOREIGN KEY ([CustomerContactKey]) REFERENCES [dbo].[DimCustomerContact] ([CustomerContactKey]),
    CONSTRAINT [FK_FactComments_UpdatedBy] FOREIGN KEY ([UpdatedByKey]) REFERENCES [dbo].[DimUser] ([UserKey]),
    CONSTRAINT [FK_FactComments_UpdatedOnDate] FOREIGN KEY ([UpdatedOnDateKey]) REFERENCES [dbo].[DimDate] ([DateKey])
);






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FactComments] TO [DataServices]
    AS [dbo];

