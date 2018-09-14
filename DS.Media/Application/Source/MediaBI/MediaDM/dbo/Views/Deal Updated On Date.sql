CREATE VIEW [dbo].[Deal Updated On Date] AS
SELECT
	[DateKey] AS [Deal Updated On Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)] 
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Deal Updated On)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Deal Updated On)]
	,[DayOfWeek] AS [Day Of Week (Deal Updated On)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Deal Updated On)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Deal Updated On)]
	,[WeekStartDate] AS [Week Start Date (Deal Updated On)]
	,[WeekEndDate] AS [Week End Date (Deal Updated On)]
	,[CalendarMonth] AS [Calendar Month (Deal Updated On)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Deal Updated On)]
	,[CalendarYearMonth] AS [Calendar Year Month (Deal Updated On)]
	,[CalendarYear] AS [Calendar Year (Deal Updated On)]
	,[IsWeekDay] AS [Is Week Day (Deal Updated On)]
	,CalendarYearFilter AS [Calendar Year Filter (Deal Updated On)]
	,CalendarMonthFilter AS [Calendar Month Filter (Deal Updated On)]
	,CalendarWeekFilter AS [Calendar Week Filter (Deal Updated On)]
	,CalendarDayFilter AS [Calendar Day Filter (Deal Updated On)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal Updated On Date] TO [DataServices]
    AS [dbo];

