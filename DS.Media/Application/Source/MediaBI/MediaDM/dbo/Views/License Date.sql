CREATE VIEW [dbo].[License Date] AS
SELECT
	[DateKey] AS [License Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (License Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (License Date)]
	,[DayOfWeek] AS [Day Of Week (License Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (License Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (License Date)]
	,[WeekStartDate] AS [Week Start Date (License Date)]
	,[WeekEndDate] AS [Week End Date (License Date)]
	,[CalendarMonth] AS [Calendar Month (License Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (License Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (License Date)]
	,[CalendarYear] AS [Calendar Year (License Date)]
	,[IsWeekDay] AS [Is Week Day (License Date)]
	,CalendarYearFilter AS [Calendar Year Filter (License Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (License Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (License Date)]
	,CalendarDayFilter AS [Calendar Day Filter (License Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[License Date] TO [DataServices]
    AS [dbo];

