CREATE PROCEDURE [dbo].[usp_PopulateDimDate]
	@start DATE = '1990-12-31',
	@end DATE = '2041-12-31'
AS

SET NOCOUNT ON;
WITH T([DATE]) AS
(
	SELECT @start as [DATE]
	UNION ALL
	SELECT DATEADD(DAY,1, T.[DATE])
	FROM T WHERE T.[DATE] > CAST('1900-01-01' as DATE) AND T.[DATE] < @end
)

INSERT INTO dbo.DimDate (
	[DateKey],
	[Date],
	[CalendarDayNumberOfMonth],
	[DayOfWeek],
	[DayNumberOfWeek],
	[CalendarWeekNumber],
	[WeekStartDate],
	[WeekEndDate],
	[CalendarMonth],
	[CalendarMonthNumberOfYear],
	[CalendarYearMonth],
	[CalendarYear],
	[IsWeekDay]
)

SELECT
	CAST(CONVERT(VARCHAR(10), [DATE], 112) AS INT) AS [DateKey],
	CAST([DATE] AS DATE) AS [Date],
	DATEPART(DAY, [DATE]) AS [CalendarDayNumberOfMonth],
	DATENAME(WEEKDAY, [DATE]) AS [DayOfWeek],
	DATEPART(WEEKDAY, [DATE]) AS [DayNumberOfWeek],
	DATEPART(WEEK, [DATE]) AS [CalendarWeekNumber],
	DATEADD(WEEKDAY, -DATEPART(dw, [DATE])+1, [DATE]) AS [WeekStartDate],
	CASE [DATE] WHEN '9999-12-31' THEN '9999-12-31'
		ELSE DATEADD(WEEKDAY, -DATEPART(dw, [DATE])+7, [DATE]) 
	END AS [WeekEndDate],
	DATENAME(MONTH, [DATE]) AS [CalendarMonth],
	DATEPART(MONTH, [DATE]) AS [CalendarMonthNumberOfYear],
	CAST(CONVERT(NVARCHAR(6), [DATE], 112) AS INT) AS [CalendarYearMonth],
	YEAR([DATE]) AS [CalendarYear],
	CASE WHEN DATEPART(WEEKDAY, [DATE]) in (1,7) THEN 'No' ELSE 'Yes' END AS IsWeekDay
FROM
	T
ORDER BY [Date] OPTION (MAXRECURSION 32767);

RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_PopulateDimDate] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimDate] TO [DataServices]
    AS [dbo];
GO
