CREATE VIEW [dbo].[Due Date] AS
SELECT
	[DateKey] AS [Due Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Due Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Due Date)]
	,[DayOfWeek] AS [Day Of Week (Due Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Due Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Due Date)]
	,[WeekStartDate] AS [Week Start Date (Due Date)]
	,[WeekEndDate] AS [Week End Date (Due Date)]
	,[CalendarMonth] AS [Calendar Month (Due Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Due Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (Due Date)]
	,[CalendarYear] AS [Calendar Year (Due Date)]
	,[IsWeekDay] AS [Is Week Day (Due Date)]
	,CalendarYearFilter AS [Calendar Year Filter (Due Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (Due Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (Due Date)]
	,CalendarDayFilter AS [Calendar Day Filter (Due Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Due Date] TO [DataServices]
    AS [dbo];

