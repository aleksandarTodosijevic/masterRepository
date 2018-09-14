CREATE VIEW [dbo].[Invoice Created On Date] AS
SELECT
	[DateKey] AS [Invoice Created On Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END  AS [Date (Invoice Created On Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Invoice Created On Date)]
	,[DayOfWeek] AS [Day Of Week (Invoice Created On Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Invoice Created On Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Invoice Created On Date)]
	,[WeekStartDate] AS [Week Start Date (Invoice Created On Date)]
	,[WeekEndDate] AS [Week End Date (Invoice Created On Date)]
	,[CalendarMonth] AS [Calendar Month (Invoice Created On Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Invoice Created On Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (Invoice Created On Date)]
	,[CalendarYear] AS [Calendar Year (Invoice Created On Date)]
	,[IsWeekDay] AS [Is Week Day (Invoice Created On Date)]
	,CalendarYearFilter AS [Calendar Year Filter (Invoice Created On Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (Invoice Created On Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (Invoice Created On Date)]
	,CalendarDayFilter AS [Calendar Day Filter (Invoice Created On Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Invoice Created On Date] TO [DataServices]
    AS [dbo];

