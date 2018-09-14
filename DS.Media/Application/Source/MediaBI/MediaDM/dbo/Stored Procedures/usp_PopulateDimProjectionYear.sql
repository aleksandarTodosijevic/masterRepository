CREATE PROCEDURE [dbo].[usp_PopulateDimProjectionYear]
	@start CHAR(4) = '1990',
	@end CHAR(4) = '2041'
AS

SET NOCOUNT ON;
WITH T([YEAR]) AS
(
	SELECT @start as [YEAR]
	UNION ALL
	SELECT CAST(T.[YEAR]+1 as char(4))
	FROM T WHERE T.[YEAR] > '1900' AND T.[YEAR] < @end
)

INSERT INTO dbo.DimProjectionYear (ProjectionYear)
SELECT
	[YEAR] AS ProjectionYear
FROM
	T
ORDER BY ProjectionYear OPTION (MAXRECURSION 100);

RETURN 0;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimProjectionYear] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimProjectionYear] TO [DataServices]
    AS [dbo];
GO
