CREATE VIEW [dbo].[DM Due Date] AS
SELECT
	[DateKey] AS [DM Due Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (DM Due Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (DM Due Date)]
	,[DayOfWeek] AS [Day Of Week (DM Due Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (DM Due Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (DM Due Date)]
	,[WeekStartDate] AS [Week Start Date (DM Due Date)]
	,[WeekEndDate] AS [Week End Date (DM Due Date)]
	,[CalendarMonth] AS [Calendar Month (DM Due Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (DM Due Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (DM Due Date)]
	,[CalendarYear] AS [Calendar Year (DM Due Date)]
	,[IsWeekDay] AS [Is Week Day (DM Due Date)]
	,CalendarYearFilter AS [Calendar Year Filter (DM Due Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (DM Due Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (DM Due Date)]
	,CalendarDayFilter AS [Calendar Day Filter (DM Due Date)]
FROM [dbo].[DimDate]
WHERE [Date] between '1900-01-01' AND '2222-01-01'

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DM Due Date] TO [DataServices]
    AS [dbo];

