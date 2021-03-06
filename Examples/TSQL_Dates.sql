

-- SQL Server current system date and conversions -- getdate() function 
SELECT Now=GETDATE()                                    -- 2016-10-23 18:59:09.483 
SELECT CONVERT(datetime, getdate())                -- 2016-10-23 18:59:09.483 
SELECT CONVERT(datetime2, getdate())               -- 2016-10-23 18:59:09.4830000 
SELECT CONVERT(smalldatetime, getdate())         -- 2016-10-23 18:59:00 
SELECT CONVERT(date, getdate())                      -- 2016-10-23 
SELECT CONVERT(datetime, CURRENT_TIMESTAMP)      -- 2016-10-23 18:59:09.483 
  
-- SQL Server current system date functions 
SELECT  SYSDATETIME()       -- 2016-10-23 19:04:34.28125007 
        ,SYSDATETIMEOFFSET() -- 2016-10-23 19:04:34.2812500 -04:00 
        ,SYSUTCDATETIME()    -- 2016-10-23 23:04:34.2812500 
        ,CURRENT_TIMESTAMP   -- 2016-10-23 19:04:34.280 
        ,GETDATE()              -- 2016-10-23 19:04:34.280 
        ,GETUTCDATE();        -- 2016-10-23 23:04:34.280 
  
-- SQL Server current system date functions with conversions 
SELECT CONVERT(datetime, SYSDATETIME())      -- 2016-10-23 19:02:19.547 
    ,CONVERT(datetime, SYSDATETIMEOFFSET()) -- 2016-10-23 19:02:19.547 
    ,CONVERT(datetime, SYSUTCDATETIME())    -- 2016-10-23 23:02:19.547 
    ,CONVERT(datetime, CURRENT_TIMESTAMP)   -- 2016-10-23 19:02:19.543 
    ,CONVERT(datetime, GETDATE())              -- 2016-10-23 19:02:19.543 
    ,CONVERT (datetime, GETUTCDATE());        -- 2016-10-23 23:02:19.543
    
-- Go back 6 days and getdat() today ------------------------------------------------------------------------------------------

DECLARE @BeginDate varchar(10)  
		,@EndDate varchar(10)  

---- Get first day of the week 
SET @BeginDate = CONVERT(VARCHAR(10),dateadd(dd,-6,datediff(dd,0,getdate())),101)	-- Last Saturday's date 


---- Get end of week
SET @EndDate = CONVERT(VARCHAR(10),GETDATE(),101)	-- Today's date

select @BeginDate AS BeginDate
		,@EndDate AS EndDate
--------------------------------------------------------------------------------------------------------------------------------		
