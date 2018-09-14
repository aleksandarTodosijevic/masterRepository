CREATE VIEW [dbo].[Ship Date]
	AS
SELECT
	[DateKey] AS [Ship Date Date Key]
	,CONVERT(datetime, convert(varchar(10), [Date])) AS [Date Key (date format)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Ship Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Ship Date)]
	,[DayOfWeek] AS [Day Of Week (Ship Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Ship Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Ship Date)]
	,[WeekStartDate] AS [Week Start Date (Ship Date)]
	,[WeekEndDate] AS [Week End Date (Ship Date)]
	,[CalendarMonth] AS [Calendar Month (Ship Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Ship Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (Ship Date)]
	,[CalendarYear] AS [Calendar Year (Ship Date)]
	,[IsWeekDay] AS [Is Week Day (Ship Date)]
	,CalendarYearFilter AS [Calendar Year Filter (Ship Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (Ship Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (Ship Date)]
	,CalendarDayFilter AS [Calendar Day Filter (Ship Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Ship Date] TO [DataServices]
    AS [dbo];

