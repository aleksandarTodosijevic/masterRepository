CREATE VIEW [dbo].[Projection Year]
AS SELECT ProjectionYear AS [Projection Year]
FROM dbo.DimProjectionYear
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Projection Year] TO [DataServices]
    AS [dbo];

