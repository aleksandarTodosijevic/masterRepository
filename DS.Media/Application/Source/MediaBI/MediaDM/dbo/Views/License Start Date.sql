CREATE VIEW [dbo].[License Start Date] AS
SELECT
	[DateKey] AS [License Start Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (License Start Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (License Start Date)]
	,[DayOfWeek] AS [Day Of Week (License Start Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (License Start Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (License Start Date)]
	,[WeekStartDate] AS [Week Start Date (License Start Date)]
	,[WeekEndDate] AS [Week End Date (License Start Date)]
	,[CalendarMonth] AS [Calendar Month (License Start Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (License Start Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (License Start Date)]
	,[CalendarYear] AS [Calendar Year (License Start Date)]
	,[IsWeekDay] AS [Is Week Day (License Start Date)]
	,CalendarYearFilter AS [Calendar Year Filter (License Start Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (License Start Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (License Start Date)]
	,CalendarDayFilter AS [Calendar Day Filter (License Start Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[License Start Date] TO [DataServices]
    AS [dbo];

