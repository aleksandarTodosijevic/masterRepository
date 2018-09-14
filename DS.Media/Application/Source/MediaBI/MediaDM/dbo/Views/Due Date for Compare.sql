
CREATE VIEW [dbo].[Due Date for Compare] AS
SELECT
	[DateKey] AS [Due Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Due Date for Compare)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Due Date for Compare)]
	,[DayOfWeek] AS [Day Of Week (Due Date for Compare)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Due Date for Compare)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Due Date for Compare)]
	,[WeekStartDate] AS [Week Start Date (Due Date for Compare)]
	,[WeekEndDate] AS [Week End Date (Due Date for Compare)]
	,[CalendarMonth] AS [Calendar Month (Due Date for Compare)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Due Date for Compare)]
	,[CalendarYearMonth] AS [Calendar Year Month (Due Date for Compare)]
	,[CalendarYear] AS [Calendar Year (Due Date for Compare)]
	,[IsWeekDay] AS [Is Week Day (Due Date for Compare)]
	,CalendarYearFilter AS [Calendar Year Filter (Due Date for Compare)]
	,CalendarMonthFilter AS [Calendar Month Filter (Due Date for Compare)]
	,CalendarWeekFilter AS [Calendar Week Filter (Due Date for Compare)]
	,CalendarDayFilter AS [Calendar Day Filter (Due Date for Compare)]
FROM [dbo].[DimDate]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Due Date for Compare] TO [DataServices]
    AS [dbo];

