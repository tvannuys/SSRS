
--Execute the following Microsoft SQL Server T-SQL script in Management Studio to create a calendar table for a specified month. 

DECLARE @Date DATE = '20161001', @StartOfWeek tinyint = 1; 
DECLARE @MM tinyint = MONTH(@Date);
DECLARE @Dates TABLE  (Date date, WeekNumber AS datepart(week, Date));
SET DATEFIRST @StartOfWeek;  -- Start week on Sunday
 
WHILE (MONTH(@Date) = @MM)
BEGIN
  INSERT @Dates (Date) SELECT @Date;
  SET @Date = DATEADD(DD,1,@Date);
END
 
SELECT Date, datename(Weekday,Date) AS Weekday, WeekNumber
FROM @Dates ORDER BY Date;
 
SELECT WeekNumber, Starts = MIN(Date), Ends=MAX(Date),
    StartDay=datename(Weekday,MIN(Date)), EndDay=datename(Weekday,MAX(Date))
FROM @Dates
GROUP BY WeekNumber
ORDER BY WeekNumber;
GO

/* 
Date		Weekday		WeekNumber
__________	__________	___________
2016-10-01	Saturday	40
2016-10-02	Sunday		40
2016-10-03	Monday		41
2016-10-04	Tuesday		41
2016-10-05	Wednesday	41
2016-10-06	Thursday	41
2016-10-07	Friday		41
2016-10-08	Saturday	41
2016-10-09	Sunday		41
2016-10-10	Monday		42
2016-10-11	Tuesday		42
2016-10-12	Wednesday	42
2016-10-13	Thursday	42
2016-10-14	Friday		42
2016-10-15	Saturday	42
2016-10-16	Sunday		42
2016-10-17	Monday		43
2016-10-18	Tuesday		43
2016-10-19	Wednesday	43
2016-10-20	Thursday	43
2016-10-21	Friday		43
2016-10-22	Saturday	43
2016-10-23	Sunday		43
2016-10-24	Monday		44
2016-10-25	Tuesday		44
2016-10-26	Wednesday	44
2016-10-27	Thursday	44
2016-10-28	Friday		44
2016-10-29	Saturday	44
2016-10-30	Sunday		44
2016-10-31	Monday		45
 
 
WeekNumber	Starts		Ends		StartDay	EndDay
__________	__________	__________	_________	________
40			2016-10-01	2016-10-02	Saturday	Sunday
41			2016-10-03	2016-10-09	Monday		Sunday
42			2016-10-10	2016-10-16	Monday		Sunday
43			2016-10-17	2016-10-23	Monday		Sunday
44			2016-10-24	2016-10-30	Monday		Sunday
45			2016-10-31	2016-10-31	Monday		Monday
 */
