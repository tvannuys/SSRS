
--CREATE PROC JT_ri_report_v2 AS

/*==========================================*
** James Tuttle		Date: 7/13/2011			*
**											*
** Purpose: Hourly report for any orders    *
** that were created since the LastRan		*
** TimeStamp.								*
**==========================================*/ 




DECLARE @LastRan AS VARCHAR(20)		-- Timestamp from local table JT_JobLog_v2
--DECLARE @Query AS VARCHAR(600)		-- Pass query to AS400

-- Get LastTime timestamp
SELECT @LastRan = JAMEST.dbo.JT_JobLog_v2.LastRan
FROM JAMEST.dbo.JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = 'JT_ri_report';



SELECT ohco as Company,
      ohloc as Location,
      ohotyp as Order_Type,
      ohord# as [Order],
      ohodat as [Date],
      ohtime as [Time],
      ohuser as [User]
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM OOHEAD
WHERE ohotyp IN(''IR'', ''RI'')
ORDER BY ohodat DESC
')
where CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
		  case len(ohtime) 
				when 5 then '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),4,2)
				else substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
end > @LastRan

-- Update the table with current time for LastTime
UPDATE JAMEST.dbo.JT_JobLog_v2
SET JAMEST.dbo.JT_JobLog_v2.LastRan =  CONVERT(VARCHAR(10),GETDATE(),120) + ' ' +REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE JAMEST.dbo.JT_JobLog_v2.JobName = 'JT_ri_report'

--  
--EXEC(@Query)


/* ---- TEST DATA ------------------------|

INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ri_report', '2011-07-13 11:00:00')

SELECT * FROM JT_JobLog_v2

DELETE FROM JT_JobLog_v2
WHERE JobName = 'JT_ri_report'

UPDATE JAMEST.dbo.JT_JobLog_v2
SET JAMEST.dbo.JT_JobLog_v2.LastRan = '2011-07-13 12:00:00'
WHERE JobName = 'JT_ri_report'
------------------------------------------------------------------------------------------------------------------------------------------------   
--> used at the column level <------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
		  case len(ohtime) 
				when 5 then '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),4,2)
		else substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
	end
	*/