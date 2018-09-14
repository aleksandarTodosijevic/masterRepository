CREATE VIEW [dbo].[Invioce Processed Date for Compare]
	AS
SELECT
	[DateKey] AS [Invoice Processed Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,[Date] AS [Date (Invoice Processed Date for Compare)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Invoice Processed Date for Compare)]
	,[DayOfWeek] AS [Day Of Week (Invoice Processed Date for Compare)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Invoice Processed Date for Compare)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Invoice Processed Date for Compare)]
	,[WeekStartDate] AS [Week Start Date (Invoice Processed Date for Compare)]
	,[WeekEndDate] AS [Week End Date (Invoice Processed Date for Compare)]
	,[CalendarMonth] AS [Calendar Month (Invoice Processed Date for Compare)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Invoice Processed Date for Compare)]
	,[CalendarYearMonth] AS [Calendar Year Month (Invoice Processed Date for Compare)]
	,[CalendarYear] AS [Calendar Year (Invoice Processed Date for Compare)]
	,[IsWeekDay] AS [Is Week Day (Invoice Processed Date for Compare)]
	,CalendarYearFilter AS [Calendar Year Filter (Invoice Processed Date for Compare)]
	,CalendarMonthFilter AS [Calendar Month Filter (Invoice Processed Date for Compare)]
	,CalendarWeekFilter AS [Calendar Week Filter (Invoice Processed Date for Compare)]
	,CalendarDayFilter AS [Calendar Day Filter (Invoice Processed Date for Compare)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Invioce Processed Date for Compare] TO [DataServices]
    AS [dbo];

