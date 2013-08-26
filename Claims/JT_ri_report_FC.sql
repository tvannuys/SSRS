
/*********************************************************************************
**																				**
** SR# 12767																	**
** Programmer: James Tuttle			Date: 07/24/2013							**
** ---------------------------------------------------------------------------- **
** Purpose:		Purpose: Hourly report for any orders							**
**				that were created since the LastRan								**
**				TimeStamp.														**
**																				**
**				pick up order type “FC” freight claim, report should go			**
**				to Ashley and Dawn.												**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_ri_report_FC AS

DECLARE @LastRan AS VARCHAR(20)						-- Timestamp from local table JT_JobLog_v2
--DECLARE @Query AS VARCHAR(600)					-- Pass query to AS400

-- Get LastTime timestamp
SELECT @LastRan = dbo.JT_JobLog_v2.LastRan
FROM dbo.JT_JobLog_v2								-- Table to store job log of time report last ran
WHERE dbo.JT_JobLog_v2.JobName = 'JT_ri_report_FC';

-- Set the @Row variable to -1 (false)----
DECLARE @Rows INT
SELECT @Rows = -1
-------------------------------------------
SELECT ohco AS Company
  ,ohloc AS Location
  ,ohotyp AS Order_Type
  ,ohord# AS [Order]
  ,ohodat AS [Date]
  ,ohtime AS [Time]
  ,ohuser AS [User]
FROM OPENQUERY (GSFL2K, '
	SELECT ohco
		,ohloc
		,ohotyp
		,ohord#
		,ohodat
		,ohtime
		,ohuser
	FROM OOHEAD
	WHERE ohotyp = ''FC''
	ORDER BY ohodat DESC
			,ohco
			,ohloc
	')
	WHERE CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
		  CASE LEN(ohtime) 
				WHEN 5 THEN '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' 
					+ substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':'
					+ substring(CONVERT(VARCHAR(7), ohtime),4,2)
				ELSE substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':'
					+ substring(CONVERT(VARCHAR(7), ohtime),3,2) 
					+ ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
END > @LastRan
--********************************************************************
-- Check row count. If nothing returned from the main Select
-- Then this will throw the Error so SSRS will not send an
-- empty email every hour.
-- users will only get an email if there is atleast one record
--********************************************************************
SELECT @Rows = @@ROWCOUNT 
IF ( @Rows < 1)
BEGIN
	RAISERROR ('No rows returned', 11, 1);
END

------------------------------------------------------------------------
-- Update the table with current time for LastTime
------------------------------------------------------------------------
UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan =  CONVERT(VARCHAR(10),GETDATE(),120) 
										+ ' ' +REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE dbo.JT_JobLog_v2.JobName = 'JT_ri_report_FC'






/*****************************************************************************
INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ri_report_FC', '2013-08-26 15:00:00')

SELECT * FROM JT_JobLog_v2

DELETE FROM JT_JobLog_v2
WHERE JobName = 'JT_ri_report_FC'

UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan = '2013-08-26 15:00:00'
WHERE JobName = 'JT_ri_report_FC'
******************************************************************************/