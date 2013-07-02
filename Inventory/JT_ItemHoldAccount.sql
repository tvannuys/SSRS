/*********************************************************************************
**																				**
** SR# 11773																	**
** Programmer: James Tuttle		Date: 06/17/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:		Hourly report on NEW items put on HOLD							**
**				for these accounts only: MISSING50,QUALITYHLD,MISSING41			**
**										 MISSING52,MISSING04,MISSING80,			**
**										 MISSING12								**
**				USe the JT_JobLog_v2 for timestamp comperasion					**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_ItemHoldAccount AS
	DECLARE @LastRan AS VARCHAR(20)		-- Timestamp from local table JT_JobLog_v2
BEGIN

-- Get LastTime timestamp -----------------------------------------------------------
SELECT @LastRan = dbo.JT_JobLog_v2.LastRan 
FROM dbo.JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = 'JT_ItemHoldAccount'

-- Query As400 ----------------------------------------------------------------------
 SELECT hlloc
	   ,Dt
	   ,hlitem
	   ,imdesc
	   ,idbin
	   ,hlqty
	   ,hluser
	   ,hlcmt
	,CONVERT(VARCHAR(10), hldate, 126) + ' ' +
		CASE LEN(hltime) 
		WHEN 5 THEN '0' + substring(CONVERT(VARCHAR(7), hltime),1,1) 
				+ ':' + substring(CONVERT(VARCHAR(7), hltime),2,2) + ':' 
				+ substring(CONVERT(VARCHAR(7), hltime),4,2)
					
		ELSE substring(CONVERT(VARCHAR(8), hltime),1,2) + ':' 
				+ substring(CONVERT(VARCHAR(8), hltime),3,2) + ':' 
				+ substring(CONVERT(VARCHAR(8), hltime),5,2) 
		END AS [time]
	
 FROM OPENQUERY(GSFL2K,	
	'SELECT hlloc
			,MONTH(hldate) || ''/'' || DAY(hldate) || ''/'' || YEAR(hldate) AS Dt
			,hlitem
			,imdesc
			,idbin
			,hlqty
			,hluser
			,hlcmt
			,hltime
			,hldate

	FROM itemhold ih
	LEFT JOIN itemmast im ON im.imitem = ih.hlitem
	LEFT JOIN itemdetl id ON (id.iditem = ih.hlitem
						AND id.idky = ih.hlky)
	
	WHERE hlcust IN(''MISSING50'',''QUALITYHLD'',''MISSING41''
					,''MISSING52'',''MISSING04'',''MISSING80'',''MISSING12'')
			
	ORDER BY hlloc
			,dt
	') 
---------------------------------------------------------------------------------------
-- Test the time: Take the time item was held and subtract an hour
-- to see if any items have been held since the last time the report
-- ran. Subscription is hourly...
----------------------------------------------------------------------------------------
where CONVERT(VARCHAR(10), hldate, 126) + ' ' +
	case len(hltime) 
		when 5 then '0' + substring(CONVERT(VARCHAR(7), hltime),1,1) + ':' 
			+ substring(CONVERT(VARCHAR(7), hltime),2,2) + ':' + substring(CONVERT(VARCHAR(7), hltime),4,2)
		else substring(CONVERT(VARCHAR(7), hltime),1,2) + ':' + substring(CONVERT(VARCHAR(7), hltime),3,2) + ':' 
			+ substring(CONVERT(VARCHAR(7), hltime),5,2) 
end > @LastRan
	
----------------------------------------------------------------------------------------


-- Update the table with current time for LastTime---------------------------------------
UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan = CONVERT(VARCHAR(10),GETDATE(),120) + ' ' 
	+REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE dbo.JT_JobLog_v2.JobName = 'JT_ItemHoldAccount'
END



/* ---- TEST DATA ---------------------------------------------------------------------------|

INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ItemHoldAccount', '2013-06-18 11:00:00')

SELECT * FROM JT_JobLog_v2

DELETE FROM JT_JobLog_v2
WHERE JobName = 'JT_ItemHoldAccount'

UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan = '2013-06-01 08:00:00'
WHERE JobName = 'JT_ItemHoldAccount'

-- JT_ItemHoldAccount

*/