USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_gl_misposted_report]    Script Date: 09/26/2013 09:58:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter PROC [dbo].[JT_gl_misposted_report] AS

/*==========================================================*
** James Tuttle		Date: 10/24/2011						*
**															*
** FROM VFP: gl-misposting-hourly-alert.prg					*
**															*
**  Purpose: Old GL Account that was used for posting		*
**==========================================================*/ 
-- Date		  By			 Ticket#/Description
-- =========  =============  ===============================
-- 9/17/2013  James Tuttle    SR# 14244 
-- Took out the ROW COUNT and will add the PARM in the SSRS 
-- to control a zero count and not email the subscription
-------------------------------------------------------------

-- "Attached are transactions posted to an old GL account by mistake."


DECLARE @LastRan AS VARCHAR(20), @Rows INT		-- Timestamp from local table JT_JobLog_v2

--SELECT @Rows = -1

-- Get LastTime timestamp
SELECT @LastRan = JT_JobLog_v2.LastRan
FROM JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = JT_JobLog_v2.JobName ;


-- Query AS400 data
SELECT *
FROM OPENQUERY (GSFL2K, '
	SELECT gld.*, bh.bhuser, bh.bhdate, bhtime
	FROM gldetl as gld JOIN glmast as glm ON gld.gdgl# = glm.glgl#
		AND gld.gdco = glm.glco
	JOIN batchhist as bh ON bh.bhkey = SUBSTR(gld.gdsrc,5)
	WHERE bh.bhaction = ''C''
		AND glm.gldelt = ''I''
		AND gld.gddate = CURRENT_DATE
		AND bh.bhdate = CURRENT_DATE

')

-- Check hour
where CONVERT(VARCHAR(10), bhtime, 126) + ' ' +
		  case len(bhtime) 
				when 5 then '0' + substring(CONVERT(VARCHAR(7), bhtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), bhtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), bhtime),4,2)
				else substring(CONVERT(VARCHAR(7), bhtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), bhtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), bhtime),5,2) 
end > @LastRan





-- Update the table with current time for LastTime
UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan =  CONVERT(VARCHAR(10),GETDATE(),120) + ' ' +REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE dbo.JT_JobLog_v2.JobName = 'JT_gl_missing_report'



----------------------------------------------------------------------
---- Check row count. If nothing returned from the main Select
---- Then this will throw the Error so SSRS will not send an
---- empty email every hour.
---- users will only get an email if there is atleast one record
				
--SELECT @Rows = @@ROWCOUNT 
--IF ( @Rows < 1)
--BEGIN
--	RAISERROR ('No rows returned', 11, 1);
--END

----------------------------------------------------------------------


/*
------------ |||   TEST DATA  ||| --------------
INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_gl_missing_report', '2011-10-24 09:00:00')

SELECT * FROM JT_JobLog_v2
*/
GO


