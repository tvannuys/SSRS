

-- AS400 convert to USA Date MM/DD/YYYY
month(ptdate) || ''/'' || day(ptdate) || ''/'' || year(ptdate) as ptdate,

-- Convert Date	-- > 11/01/2012
SELECT @BeginDate
SET @BeginDate = CONVERT(varchar, DATEADD(M,-1,@BeginDate), 101)
--------------------------------------------------------------------------------------------------------
-- Date and then back  a month off the variable dates---------------------------------------------------
--
DECLARE @BeginDate varchar(10), @EndDate varchar(10)
SET @BeginDate = '01/01/2012'
SET @EndDate = '01/31/2012'
																	-- @BeginDate	@EndDate
SELECT @BeginDate as BeginDate, @EndDate as EndDate					-- 01/01/2012	01/31/2012

SET @BeginDate = CONVERT(varchar, DATEADD(M,-1,@BeginDate), 101) 
SET @EndDate = CONVERT(varchar, DATEADD(M,-1,@EndDate), 101)		-- @BeginDate	@EndDate
SELECT @BeginDate as BeginDate, @EndDate as EndDate					-- 12/01/2011	12/31/2011
--------------------------------------------------------------------------------------------------------

DECLARE @BeginDate varchar(10), @EndDate varchar(10)

-- Get first day of the month 5 months back
SET @BeginDate = CONVERT(varchar(10),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,-5,GETDATE())),101) 

-- Get end of month from the prior month
SET @EndDate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(GETDATE())),GETDATE()),101)
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--Convert Time
hour(ptdatets) ||'':'' || minute(ptdatets) || '':'' || second(ptdatets) as ptdatets


-- Subtract DAYS in AS400 SQL
DAYS(CURRENT_DATE) - DAYS(id.iddate) as age_in_days

----------------------------------------------------------------------------------------------------------
-- Time convert in SQL
-- DECLARE @DB2Time NUMERIC(6, 0) = 104522

SELECT CAST( SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),@DB2Time),6),1,2) + ':'
       + SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),@DB2Time),6),3,2) + ':'
       + SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),@DB2Time),6),5,2) AS TIME)
       
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------