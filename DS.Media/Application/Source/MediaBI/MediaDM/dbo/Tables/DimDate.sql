CREATE TABLE [dbo].[DimDate] (
    [DateKey]                   INT           NOT NULL,
    [Date]                      DATE          NOT NULL,
    [CalendarDayNumberOfMonth]  INT           NOT NULL,
    [DayOfWeek]                 NVARCHAR (30) NOT NULL,
    [DayNumberOfWeek]           INT           NOT NULL,
    [CalendarWeekNumber]        INT           NOT NULL,
    [WeekStartDate]             DATE          NOT NULL,
    [WeekEndDate]               DATE          NOT NULL,
    [CalendarMonth]             NVARCHAR (30) NOT NULL,
    [CalendarMonthNumberOfYear] INT           NOT NULL,
    [CalendarYearMonth]         INT           NOT NULL,
    [CalendarYear]              INT           NOT NULL,
    [IsWeekDay]                 VARCHAR (3)   NOT NULL,
    [CalendarYearFilter]        AS            (case datepart(year,[Date]) when datepart(year,dateadd(day,(-1),getdate())) then 'This Year' when datepart(year,dateadd(year,(-1),dateadd(day,(-1),getdate()))) then 'Last Year' when datepart(year,dateadd(year,(1),dateadd(day,(-1),getdate()))) then 'Next Year' else 'No' end),
    [CalendarMonthFilter]       AS            (case CONVERT([int],CONVERT([nvarchar](6),[Date],(112))) when CONVERT([int],CONVERT([nvarchar](6),dateadd(day,(-1),getdate()),(112))) then 'This Month' when CONVERT([int],CONVERT([nvarchar](6),dateadd(month,(-1),dateadd(day,(-1),getdate())),(112))) then 'Last Month' when CONVERT([int],CONVERT([nvarchar](6),dateadd(month,(1),dateadd(day,(-1),getdate())),(112))) then 'Next Month' else 'No' end),
    [CalendarWeekFilter]        AS            (case CONVERT([nvarchar](4),datepart(year,[Date]))+CONVERT([nvarchar](2),datepart(week,[Date])) when CONVERT([nvarchar](4),datepart(year,dateadd(day,(-1),getdate())))+CONVERT([nvarchar](2),datepart(week,dateadd(day,(-1),getdate()))) then 'This Week' when CONVERT([nvarchar](4),datepart(year,dateadd(week,(-1),getdate())))+CONVERT([nvarchar](2),datepart(week,dateadd(week,(-1),getdate()))) then 'Last Week' when CONVERT([nvarchar](4),datepart(year,dateadd(week,(1),getdate())))+CONVERT([nvarchar](2),datepart(week,dateadd(week,(1),getdate()))) then 'Next Week' else 'No' end),
    [CalendarDayFilter]         AS            (case CONVERT([date],[Date]) when CONVERT([date],getdate()) then 'Today' when dateadd(day,(-1),CONVERT([date],getdate())) then 'Yesterday' when dateadd(day,(1),CONVERT([date],getdate())) then 'Tomorrow' else 'No' end),
    CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED ([DateKey] ASC)
);








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DimDate] TO [DataServices]
    AS [dbo];

