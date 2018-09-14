CREATE VIEW [dbo].[Invoice Processed Date] AS
SELECT
	[DateKey] AS [Invoice Processed Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Invoice Processed Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Invoice Processed Date)]
	,[DayOfWeek] AS [Day Of Week (Invoice Processed Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Invoice Processed Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Invoice Processed Date)]
	,[WeekStartDate] AS [Week Start Date (Invoice Processed Date)]
	,[WeekEndDate] AS [Week End Date (Invoice Processed Date)]
	,[CalendarMonth] AS [Calendar Month (Invoice Processed Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Invoice Processed Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (Invoice Processed Date)]
	,[CalendarYear] AS [Calendar Year (Invoice Processed Date)]
	,[IsWeekDay] AS [Is Week Day (Invoice Processed Date)]
	,CalendarYearFilter AS [Calendar Year Filter (Invoice Processed Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (Invoice Processed Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (Invoice Processed Date)]
	,CalendarDayFilter AS [Calendar Day Filter (Invoice Processed Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Invoice Processed Date] TO [DataServices]
    AS [dbo];

