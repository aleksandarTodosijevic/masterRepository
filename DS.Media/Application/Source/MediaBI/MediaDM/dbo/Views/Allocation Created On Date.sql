
CREATE VIEW [dbo].[Allocation Created On Date] AS
SELECT
	[DateKey] AS [Allocation Created On Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END  AS [Date (Allocation Created On)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Allocation Created On)]
	,[DayOfWeek] AS [Day Of Week (Allocation Created On)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Allocation Created On)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Allocation Created On)]
	,[WeekStartDate] AS [Week Start Date (Allocation Created On)]
	,[WeekEndDate] AS [Week End Date (Allocation Created On)]
	,[CalendarMonth] AS [Calendar Month (Allocation Created On)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Allocation Created On)]
	,[CalendarYearMonth] AS [Calendar Year Month (Allocation Created On)]
	,[CalendarYear] AS [Calendar Year (Allocation Created On)]
	,[IsWeekDay] AS [Is Week Day (Allocation Created On)]
	,CalendarYearFilter AS [Calendar Year Filter (Allocation Created On)]
	,CalendarMonthFilter AS [Calendar Month Filter (Allocation Created On)]
	,CalendarWeekFilter AS [Calendar Week Filter (Allocation Created On)]
	,CalendarDayFilter AS [Calendar Day Filter (Allocation Created On)]
FROM [dbo].[DimDate]
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Allocation Created On Date] TO [DataServices]
    AS [dbo];

