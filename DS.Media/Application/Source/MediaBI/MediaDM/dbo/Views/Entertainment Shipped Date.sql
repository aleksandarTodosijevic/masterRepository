CREATE VIEW [dbo].[Entertainment Shipped Date]
	AS 
SELECT
	[DateKey] AS [Entertainment Shipped Date Key]
	,CONVERT(Date, CONVERT(varchar(10), [Date])) AS [Date Key (Date Formatted)]
    ,CASE WHEN [DateKey] = 19000101 THEN NULL ELSE  [Date]  END AS [Date (Entertainment Shipped Date)]
	,[CalendarDayNumberOfMonth] AS [Calendar Day Number Of Month (Entertainment Shipped Date)]
	,[DayOfWeek] AS [Day Of Week (Entertainment Shipped Date)]
	,[DayNumberOfWeek] AS [Day Number Of Week (Entertainment Shipped Date)]
	,[CalendarWeekNumber] AS [Calendar Week Number (Entertainment Shipped Date)]
	,[WeekStartDate] AS [Week Start Date (Entertainment Shipped Date)]
	,[WeekEndDate] AS [Week End Date (Entertainment Shipped Date)]
	,[CalendarMonth] AS [Calendar Month (Entertainment Shipped Date)]
	,[CalendarMonthNumberOfYear] AS [Calendar Month Number Of Year (Entertainment Shipped Date)]
	,[CalendarYearMonth] AS [Calendar Year Month (Entertainment Shipped Date)]
	,[CalendarYear] AS [Calendar Year (Entertainment Shipped Date)]
	,[IsWeekDay] AS [Is Week Day (Entertainment Shipped Date)]
	,CalendarYearFilter AS [Calendar Year Filter (Entertainment Shipped Date)]
	,CalendarMonthFilter AS [Calendar Month Filter (Entertainment Shipped Date)]
	,CalendarWeekFilter AS [Calendar Week Filter (Entertainment Shipped Date)]
	,CalendarDayFilter AS [Calendar Day Filter (Entertainment Shipped Date)]
FROM [dbo].[DimDate]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Entertainment Shipped Date] TO [DataServices]
    AS [dbo];
