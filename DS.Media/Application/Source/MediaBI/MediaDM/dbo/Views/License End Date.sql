CREATE VIEW [dbo].[License End Date] AS
SELECT
	[DateKey] AS [License End Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (License End Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (License End Date)]
	,[DayOfWeek] AS [Day Of Week (License End Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (License End Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (License End Date)]
	,[WeekStartDate] AS [Week Start Date (License End Date)]
	,[WeekEndDate] AS [Week End Date (License End Date)]
	,[CalendarMonth] AS [Calendar Month (License End Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (License End Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (License End Date)]
	,[CalendarYear] AS [Calendar Year (License End Date)]
	,[IsWeekDay] AS [Is Week Day (License End Date)]
	,CalendarYearFilter AS [Calendar Year Filter (License End Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (License End Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (License End Date)]
	,CalendarDayFilter AS [Calendar Day Filter (License End Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[License End Date] TO [DataServices]
    AS [dbo];

