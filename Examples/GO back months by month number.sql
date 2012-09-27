--set showplan_text off
--GO  


DECLARE @PrMonth int
	,@Month2 varchar(3)
	,@Month3 varchar(3)
	,@Month4 varchar(3)
	,@Month5 varchar(3)

--DECLARE @PrMonth varchar(2)
-- Get prior month's numeric value
SET @PrMonth = CONVERT(int,DATEPART(month,DATEADD(m, -1, GETDATE())))  -- Prior Month
SET @Month2 = CONVERT(VARCHAR(3),DATEPART(month,DATEADD(m, -2, GETDATE()))) -- Two months back
SET @Month3 = CONVERT(VARCHAR(3),DATEPART(month,DATEADD(m, -3, GETDATE()))) -- Three months back
SET @Month4 = CONVERT(VARCHAR(3),DATEPART(month,DATEADD(m, -4, GETDATE()))) -- Four months back
SET @Month5 = CONVERT(VARCHAR(3),DATEPART(month,DATEADD(m, -5, GETDATE()))) -- Five months back


SELECT @PrMonth AS [Pr Month]
	,@Month2 AS [2 Months]
	--,CONVERT(VARCHAR(3),DATEPART(month,@Month2)) 
	,@Month3 AS [3 Months]
	,@Month4 AS [4 Months]
	,@Month5 AS [5 Months]

--DECLARE @d	varchar(2)
--SET	@d = DATEPART(month,DATEADD(m, -1, GETDATE()))
--SELECT @d