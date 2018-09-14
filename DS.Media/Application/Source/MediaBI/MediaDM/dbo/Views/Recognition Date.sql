CREATE VIEW [dbo].[Recognition Date]
	AS 
SELECT
	[DateKey] AS [Recognition Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Recognition Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Recognition Date)]
	,[DayOfWeek] AS [Day Of Week (Recognition Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Recognition Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Recognition Date)]
	,[WeekStartDate] AS [Week Start Date (Recognition Date)]
	,[WeekEndDate] AS [Week End Date (Recognition Date)]
	,[CalendarMonth] AS [Calendar Month (Recognition Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Recognition Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (Recognition Date)]
	,[CalendarYear] AS [Calendar Year (Recognition Date)]
	,[IsWeekDay] AS [Is Week Day (Recognition Date)]
	,CalendarYearFilter AS [Calendar Year Filter (Recognition Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (Recognition Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (Recognition Date)]
	,CalendarDayFilter AS [Calendar Day Filter (Recognition Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Recognition Date] TO [DataServices]
    AS [dbo];
