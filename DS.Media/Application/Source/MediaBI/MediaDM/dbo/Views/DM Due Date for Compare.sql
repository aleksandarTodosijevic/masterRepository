CREATE VIEW [dbo].[DM Due Date for Compare] AS
SELECT
	[DateKey] AS [DM Due Date for Compare Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (DM Due Date for Compare)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (DM Due Date for Compare)]
	,[DayOfWeek] AS [Day Of Week (DM Due Date for Compare)]
	,[DayNumberOfWeek] AS [Day Number Of Week (DM Due Date for Compare)]
	,[CalendarWeekNumber] AS [Calendar Week Number (DM Due Date for Compare)]
	,[WeekStartDate] AS [Week Start Date (DM Due Date for Compare)]
	,[WeekEndDate] AS [Week End Date (DM Due Date for Compare)]
	,[CalendarMonth] AS [Calendar Month (DM Due Date for Compare)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (DM Due Date for Compare)]
	,[CalendarYearMonth] AS [Calendar Year Month (DM Due Date for Compare)]
	,[CalendarYear] AS [Calendar Year (DM Due Date for Compare)]
	,[IsWeekDay] AS [Is Week Day (DM Due Date for Compare)]
	,CalendarYearFilter AS [Calendar Year Filter (DM Due Date for Compare)]
	,CalendarMonthFilter AS [Calendar Month Filter (DM Due Date for Compare)]
	,CalendarWeekFilter AS [Calendar Week Filter (DM Due Date for Compare)]
	,CalendarDayFilter AS [Calendar Day Filter (DM Due Date for Compare)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DM Due Date for Compare] TO [DataServices]
    AS [dbo];

