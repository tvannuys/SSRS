
--ALTER PROC JT_ra_inv_n_report_v2 AS 

DECLARE @LastRan AS VARCHAR(20)		-- Timestamp from local table JT_JobLog_v2

-- Get LastTime timestamp
SELECT @LastRan = dbo.JT_JobLog_v2.LastRan 
FROM dbo.JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = 'JT_ra_inv_n_report'



-- Query AS400 for orders that are greater than LastTime time stamp
SELECT ohco as Company,
	ohloc as Location,
	ohotyp as Order_Type,
	ohord# as [Order],
	olitem as Item,
	oldesc as [Description],
	ohcm as Credit_Memo,
	olbyp as Bypass_Inventory,
	oldiv as Division,
	olcls# as Class, 
	ohtime as [Time],
	ohodat as [Date],
	ohuser as [User]
FROM OPENQUERY (GSFL2K, 'SELECT *
FROM OOHEAD INNER JOIN OOLINE ON ohco = olco
	AND ohloc = olloc
	AND ohord# = olord#
	AND ohrel# = olrel#
	AND ohcm = ''Y''
	AND olbyp = ''N''
	AND ohcred != ''XX''
	AND olcls# NOT BETWEEN 13000 AND 13997
	AND ohotyp NOT IN(''CL'', ''FC'')
	')
where CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
	case len(ohtime) 
		when 5 then '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),4,2)
		else substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
end > @LastRan


-->
-- Update the table with current time for LastTime
UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan = CONVERT(VARCHAR(10),GETDATE(),120) + ' ' +REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE dbo.JT_JobLog_v2.JobName = 'JT_ra_inv_n_report'


--EXEC(@Query)



/* ---- TEST DATA ------------------------|

INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ra_inv_n_report', '2011-07-13 11:00:00')

SELECT * FROM JT_JobLog_v2

DELETE FROM JT_JobLog_v2
WHERE JobName = 'JT_ra_inv_n_report'

UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan = '2011-07-13 11:00:00'
WHERE JobName = 'JT_ra_inv_n_report'


*/