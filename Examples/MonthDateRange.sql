
-- Get dates for a month for a date range report

DECLARE  @BeginDate varchar(10)
		,@EndDate varchar(10) 

	-- Beginning day of the month
	SET @BeginDate = CONVERT(VARCHAR(10),DATEADD(m,-1, Dateadd(d,1-DATEPART(d,getdate()),GETDATE())), 101)
	-- Last day of the prior month
	SET @EndDate = CONVERT(varchar(10), dateadd(mm,-1,DATEADD(dd,-DAY(getdate()),DATEADD(mm,1,getdate()))), 101)
	
	