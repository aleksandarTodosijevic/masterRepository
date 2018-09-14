CREATE VIEW [dbo].[Deal Created On Date] AS
SELECT
	[DateKey] AS [Deal Created On Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)] 
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Deal Created On)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Deal Created On)]
	,[DayOfWeek] AS [Day Of Week (Deal Created On)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Deal Created On)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Deal Created On)]
	,[WeekStartDate] AS [Week Start Date (Deal Created On)]
	,[WeekEndDate] AS [Week End Date (Deal Created On)]
	,[CalendarMonth] AS [Calendar Month (Deal Created On)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Deal Created On)]
	,[CalendarYearMonth] AS [Calendar Year Month (Deal Created On)]
	,[CalendarYear] AS [Calendar Year (Deal Created On)]
	,[IsWeekDay] AS [Is Week Day (Deal Created On)]
	,CalendarYearFilter AS [Calendar Year Filter (Deal Created On)]
	,CalendarMonthFilter AS [Calendar Month Filter (Deal Created On)]
	,CalendarWeekFilter AS [Calendar Week Filter (Deal Created On)]
	,CalendarDayFilter AS [Calendar Day Filter (Deal Created On)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Deal Created On Date] TO [DataServices]
    AS [dbo];

