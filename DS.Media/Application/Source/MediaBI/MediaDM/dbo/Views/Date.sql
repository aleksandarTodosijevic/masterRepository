CREATE VIEW [dbo].[Date] AS
SELECT
	DateKey AS [Date Key]
    ,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (date format)] 
	,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month]
	,[DayOfWeek] AS [Day Of Week]
	,[DayNumberOfWeek] AS [Day Number Of Week]
	,[CalendarWeekNumber] AS [Calendar Week Number]
	,[WeekStartDate] AS [Week Start Date]
	,[WeekEndDate] AS [Week End Date]
	,[CalendarMonth] AS [Calendar Month]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year]
	,[CalendarYearMonth] AS [Calendar Year Month]
	,[CalendarYear] AS [Calendar Year]
	,[IsWeekDay] AS [Is Week Day]
	,CalendarYearFilter AS [Calendar Year Filter]
	,CalendarMonthFilter AS [Calendar Month Filter]
	,CalendarWeekFilter AS [Calendar Week Filter]
	,CalendarDayFilter AS [Calendar Day Filter]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Date] TO [DataServices]
    AS [dbo];

