
--CREATE PROC JT_ri_report AS 

DECLARE @LastRan AS VARCHAR(10)		-- Timestamp from local table JT_JobLog
DECLARE @Query AS VARCHAR(600)		-- Pass query to AS400

-- Get LastTime timestamp
SELECT @LastRan = JAMEST.dbo.JT_JobLog.LastTime 
FROM JAMEST.dbo.JT_JobLog --> Table to store job log of time report last ran
WHERE JT_JobLog.JobName = 'JT_ri_report'


-- Query AS400 for orders that are greater than LastTime time stamp
/*set @Query = 'SELECT  *
FROM OPENQUERY (GSFL2K, ''SELECT  ohco,
	ohloc,
	ohotyp,
	ohord#,
	ohdate, 
	ohtime,
	ohuser
FROM OOHEAD
WHERE ohtime >= ' + @LastRan + '
	AND ohdate = CURRENT_DATE'') 
WHERE ohotyp IN(''''IR'''', ''''RI'''')'   */
/*
set @Query = 'SELECT ohco,
        ohloc,
        ohotyp,
        ohord#,
        ohodat,
        ohtime,
        ohuser
FROM OPENQUERY (GSFL2K, ''SELECT *
FROM OOHEAD''  )
WHERE ohotyp IN(''IR'', ''RI'')
AND ohodat + '' '' + ohtime = CONVERT
>= CONVERT(datetime, ''' + @LastRan + ''', 126) ' 

select CONVERT(VARCHAR(10), GETDATE(), 8), ':', ''
*/


set @Query = 'SELECT ohco,
	ohloc,
	ohotyp,
	ohord#,
	ohodat,
	ohtime,
	ohuser
FROM OPENQUERY (GSFL2K, ''SELECT *
FROM OOHEAD''  )
WHERE ohotyp IN(''IR'', ''RI'')
AND CONVERT(VARCHAR(10), ohodat, 126)+ '' '' + CONVERT(VARCHAR(7), ohtime) >= '' + @LastRan + '' ' 





-->
-- Update the table with current time for LastTime
UPDATE JAMEST.dbo.JT_JobLog
SET JAMEST.dbo.JT_JobLog.LastTime = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 8), ':', '')
WHERE JAMEST.dbo.JT_JobLog.JobName = 'JT_ri_report'


EXEC(@Query)


/* ---- TEST DATA ------------------------|
INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ri_report', '2011-07-12 07:25:22')
SELECT * FROM JT_JobLog_v2
DELETE FROM JT_JobLog

update JT_JobLog
SET LastTime = '105999'
WHERE JobName = 'JT_ri_report'

    Time   Date      
                     
 103,032   2010-12-07



SELECT REPLACE(CONVERT(VARCHAR(10), GETDATE(), 8), ':', '')


SELECT * FROM @Query
*/