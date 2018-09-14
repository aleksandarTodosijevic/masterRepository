


CREATE VIEW [dbo].[Allocation Updated On Date] AS
SELECT
	[DateKey] AS [Allocation Updated On Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE [Date] END AS [Date (Allocation Updated On)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Allocation Updated On)]
	,[DayOfWeek] AS [Day Of Week (Allocation Updated On)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Allocation Updated On)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Allocation Updated On)]
	,[WeekStartDate] AS [Week Start Date (Allocation Updated On)]
	,[WeekEndDate] AS [Week End Date (Allocation Updated On)]
	,[CalendarMonth] AS [Calendar Month (Allocation Updated On)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Allocation Updated On)]
	,[CalendarYearMonth] AS [Calendar Year Month (Allocation Updated On)]
	,[CalendarYear] AS [Calendar Year (Allocation Updated On)]
	,[IsWeekDay] AS [Is Week Day (Allocation Updated On)]
	,CalendarYearFilter AS [Calendar Year Filter (Allocation Updated On)]
	,CalendarMonthFilter AS [Calendar Month Filter (Allocation Updated On)]
	,CalendarWeekFilter AS [Calendar Week Filter (Allocation Updated On)]
	,CalendarDayFilter AS [Calendar Day Filter (Allocation Updated On)]
FROM [dbo].[DimDate]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Allocation Updated On Date] TO [DataServices]
    AS [dbo];

