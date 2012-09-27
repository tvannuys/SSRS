
--CREATE PROC JT_ri_report_test_null AS 

-- Drop the TEMP TABLE
IF OBJECT_ID ('tempdb,#temp') is not null
DROP table #temp


-- Create Temp Table for record check
CREATE TABLE #temp
 (
 ohco	VARCHAR(3),
 ohloc	VARCHAR(2),
 ohtyp	VARCHAR(2),
 ohord# VARCHAR(6),
 ohdate DATE,
 ohtime VARCHAR(8),
 ohuser VARCHAR(10)
 )
 GO
 
DECLARE @LastRan AS VARCHAR(10)		-- Timestamp from local table JT_JobLog
DECLARE @Query AS VARCHAR(500)		-- Pass query to AS400

 
-- Get LastTime timestamp
SELECT @LastRan = JAMEST.dbo.JT_TEST_JobLog.LastTime 
FROM JAMEST.dbo.JT_TEST_JobLog --> Table to store job log of time report last ran
WHERE JT_TEST_JobLog.JobName = 'JT_ri_report'



-- Query AS400 for orders that are greater than LastTime time stamp
set @Query = 'SELECT  *
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
WHERE ohotyp IN(''''IR'''', ''''RI'''')'	



INSERT INTO #temp EXEC(@Query)

IF (SELECT COUNT(*) FROM #temp) > 0
BEGIN
	-- Update the table with current time for LastTime
	UPDATE JAMEST.dbo.JT_TEST_JobLog
	SET JAMEST.dbo.JT_TEST_JobLog.LastTime = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 8), ':', '')
	WHERE JAMEST.dbo.JT_TEST_JobLog.JobName = 'JT_ri_report'

	EXEC(@Query)
END



/* ---- TEST DATA ------------------------|
INSERT INTO JT_TEST_JobLog (JobName, LastTime, LastDate)
VALUES ('JT_ri_report_test_null', REPLACE(CONVERT(VARCHAR(10), GETDATE(), 8), ':', ''),GETDATE())
SELECT * FROM JT_TEST_JobLog
DELETE FROM JT_TEST_JobLog

    Time   Date      
                     
 103,032   2010-12-07



SELECT REPLACE(CONVERT(VARCHAR(10), GETDATE(), 8), ':', '')


SELECT * FROM @Query
*/