USE [msdb]
GO

/****** Object:  Job [WarehouseProductivity_V2]    Script Date: 04/19/2012 13:42:39 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 04/19/2012 13:42:39 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'WarehouseProductivity_V2', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Series of steps that captures warehouse productivity statistics', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TASUPPLY\thomasv', 
		@notify_email_operator_name=N'James', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [TruncateOldData]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'TruncateOldData', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Truncate table [WarehouseProductivity]', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Cuts]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Cuts', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'delete WarehouseProductivity where Metric = ''CUTS''
go

insert WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
''CUTS'',
lineItemsForCutsColumn

from openquery(GSFL2K,''

select olrico, 
olrilo,
olrdat,
olrusr,
count(*) as lineItemsForCutsColumn
  from oolrfuser hst
 where hst.olrtyp = ''''C''''
      AND hst.olrdat >= ''''2011-10-15''''
   and hst.olrtim >= 000001 
   and hst.olrdat <= current_date 
   and hst.olrtim <= 235959 
   
   group by olrico, olrilo,olrdat,olrusr
'')
', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Rolls Moved]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Rolls Moved', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--***************************
--*   ROLLS MOVED COLUMN    *
--***************************

delete WarehouseProductivity where Metric = ''Rolls Moved''
go

insert WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
''Rolls Moved'',
lineItemsForRollsMovedColumn
from openquery(GSFL2K,''

select olrico, 
olrilo,
olrdat,
olrusr,
count(*) as lineItemsForRollsMovedColumn
  from oolrfuser hst
 where hst.olrtyp = ''''M''''
    AND hst.olrdat >= ''''2011-10-15''''
   and hst.olrtim >= 000001 
   and hst.olrdat <= current_date 
   and hst.olrtim <= 235959 
group by olrico, olrilo,olrdat,olrusr
'')', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Staged]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Staged', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--***************************
--*      STAGED COLUMN      *
--***************************

-- ** Get Line Items row ** 

delete WarehouseProductivity where Metric = ''Staged''
go

insert WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
''Staged'',
lineItemsForStagedColumn
 from openquery(gsfl2k,''

select olrico, 
olrilo,
olrdat,
olrusr,
count(*) as lineItemsForStagedColumn
  from oolrfuser hst
 where hst.olrtyp = ''''S''''
   and not exists ( 
                   select 1
                     from rfwillchsx wcc 
                    where hst.olrco = wcc.rfoco
                      and hst.olrloc = wcc.rfoloc
                      and hst.olrord = wcc.rfoord#
                      and hst.olrrel = wcc.rforel#
                      and hst.olrusr = wcc.rpuser
                  )
 AND hst.olrdat >= ''''2011-10-15''''
   and hst.olrtim >= 000001 
   and hst.olrdat <= current_date 
   and hst.olrtim <= 235959 
group by olrico, olrilo,olrdat,olrusr
'')
', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - xe_ship_plt_tag]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - xe_ship_plt_tag', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE ship Items by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Item Ship by Plt Tag''
GO



 WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, olrdat) AS PltCnt		
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Item Ship by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,itxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						     AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal != 0
							/*AND hst.olrord = 857136*/
						'')
GROUP BY usxemp# 
	,itxpal 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User]

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT olrico,
							  olrilo,
							  olrord,
							  olrrel,
							  olritm,
							  olrseq,
							  olrtyp,
							  olrusr,
							  itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							/*AND hst.olrord = 854483	 */
							AND xe.itxpal != 0
							AND ux.usxemp# = 2016		
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - xe_ship_no_plt_tag]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - xe_ship_no_plt_tag', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE items shipped ** No Pallet Tag**
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Items Ship Non Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Items Ship Non Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal = 0
						'')
GROUP BY usxemp# 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT olrico
							  ,olrilo
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal = 0
							/*AND hst.olrord = 854483	*/ 
							/*AND ux.usxemp# = 1484		*/
						ORDER BY  olrusr
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - xe_ship_cut_plt_tag]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - xe_ship_cut_plt_tag', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE receive Rolls by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- 
DELETE WarehouseProductivity 
WHERE Metric = ''XE Rolls Ship by Plt Tag''
GO

WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, olrdat ) AS PltCnt			
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Rolls Ship by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,itxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						       AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal != 0
							/*AND hst.olrord = 857136*/
						'')
GROUP BY usxemp# 
	,itxpal 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User]


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
	FROM OPENQUERY(GSFL2K,''SELECT itpco
							  ,itploc
							  ,olrco
							  ,olrloc
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''''T''''
							/* AND hst.olrord = 853016	*/
							AND xe.itxpal != 0
							AND xe.itcut = ''''Y''''
							AND ux.usxemp# = 2016		
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - xe_ship_cut_no_plt_tag]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - xe_ship_cut_no_plt_tag', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE rolls shipped ** No Pallet Tag**
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Rolls Ship Non Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Rolls Ship Non Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						       AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''''T''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal = 0
							/*AND hst.olrord = 857136*/
						'')
GROUP BY usxemp# 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT olrico
							  ,olrilo
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal = 0
							/*AND hst.olrord = 854483	*/ 
							/*AND ux.usxemp# = 1484		*/
						ORDER BY  olrusr
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - trk_cuts_no_plt_tag]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - trk_cuts_no_plt_tag', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Non XE on Delivery truck for Roll Goods with ** NO Pallet Tag ** 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Truck Roll Counts Non Plt''
GO

-- NO Pallet Tag
 WITH CTE AS (
 	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''Truck Roll Non Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
					,emname
					,slxpal
					,olrico
					,olrilo
					,olrdat
					,olrusr
					,olritm
				FROM oolrfhst hst
				INNER JOIN shline sl
				ON(sl.slico = hst.olrico
					AND sl.sliloc = hst.olrilo
					AND sl.slord# = hst.olrord
					AND sl.slrel# = hst.olrrel
					AND sl.slitem = hst.olritm
					AND sl.slseq# = hst.olrseq)
				INNER JOIN shhead sh
				ON (sh.shco = sl.slco
					AND sh.shloc = sl.slloc
					AND sh.shord# = sl.slord#
					AND sh.shrel# = sl.slrel#
					AND sh.shcust = sl.slcust)
				INNER JOIN userxtra ux
				ON hst.olrusr = ux.usxid
				INNER JOIN userfile uf
				ON ux.usxid = uf.usid
				INNER JOIN prempm em
				ON em.ememp# = 	ux.usxemp#	
				WHERE hst.olrico = 1
					AND hst.olrilo = 50
					AND hst.olrdat >= ''''2012-10-15''''
					AND hst.olrtim >= 000001 
					AND hst.olrdat <= current_date 
					AND hst.olrtim <= 235959  
					AND hst.olrtyp = ''''T''''
					AND sl.slcut = ''''Y''''
					AND sl.slxpal = 0
					AND sh.shviac NOT IN(''''1'''',''''6'''')			
			'')
GROUP BY usxemp# 
	,slxpal 
	,emname
	,olrico
  	  ,olrilo
   	 ,olrdat
 	   ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT olrico,
							  olrilo,
							  olrord,
							  olrrel,
							  olritm,
							  olrseq,
							  olrtyp,
							  olrusr,
							  shviac,
							  slxpal
						FROM oolrfhst hst
						/*INNER JOIN transfer xe
							ON (hst.olrico = xe.itico
								AND hst.olrilo = xe.itiloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#)*/
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND sl.slcut = ''''Y''''
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''''1'''',''''6'''')
							/*AND  ux.usxemp#= 1412 */
							/*AND hst.olrord = 848887*/
							
							
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - trk_cuts_plt_tag]    Script Date: 04/19/2012 13:42:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - trk_cuts_plt_tag', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Non XE on Delivery truck by Pallet Tag for Roll Goods 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Truck Rolls by Plt Tag''
GO

-- By Pallet Tag
 WITH CTE AS (
	SELECT COUNT( slxpal) OVER(PARTITION BY usxemp#, olrdat) AS PltCnt
	,olrico 
	,olrilo 
	,convert(datetime,olrdat,101) as RFDate
	,olrusr 
	,''Truck Rolls by Plt Tag'' as [type]
	,usxemp# AS [User]
	,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,slxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-01-01''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND sl.slcut = ''''Y''''
							AND sl.slxpal != 0
							AND sh.shviac NOT IN(''''1'''',''''6'''')
						'')
	GROUP BY usxemp# 
		,slxpal 
		,emname
		,olrico
		,olrilo
		,olrdat
		,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[type] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[type]
	,CTE.RFDate
ORDER BY CTE.[User] 

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT olrico
							  ,olrilo
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,olrdat
							  ,shviac
							  ,slxpal
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-01-01''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND sl.slxpal != 0
							AND sl.slcut = ''''Y''''
							/*AND  ux.usxemp#= 1593 */
							/*AND hst.olrord = 848887*/
							AND sh.shviac NOT IN(''''1'''',''''6'''')
							
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - trk_no_plt_tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - trk_no_plt_tag', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Non XE on Delivery truck by item ** No Pallet Tag**
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Truck Items Non Plt Tag''
GO

-- NO Pallet Tag
 WITH CTE AS (
	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''Truck Items Non Plt Tagt'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,slxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''''T''''
							AND sl.slcut != ''''Y''''
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''''1'''',''''6'''')
						
						'')
GROUP BY usxemp# 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,slxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
							AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''''T''''
							AND sl.slcut != ''''Y''''
							AND sl.slxpal = 0
							AND sh.shviac NOT IN(''''1'''',''''6'''')
							/*AND  ux.usxemp#= 1412 */
							/*AND hst.olrord = 848887*/
							
							
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ship - trk_plt_tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ship - trk_plt_tag', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Non XE on Delivery truck by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Truck Item by Plt Tag''
GO

-- By Pallet Tag
-- partition off of usxemp# and olrdat
 WITH CTE AS (
	SELECT COUNT( slxpal) OVER(PARTITION BY usxemp#, olrdat) AS PltCnt  
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''Truck Item by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,slxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''T''''
							AND sl.slcut != ''''Y''''
							AND sl.slxpal != 0
							AND sh.shviac NOT IN(''''1'''',''''6'''')				
						'')
GROUP BY usxemp# 
	,slxpal 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT olrico
							  ,olrilo
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,olrdat
							  ,shviac
							  ,slxpal
						FROM oolrfhst hst
						INNER JOIN shline sl
							ON(sl.slico = hst.olrico
								AND sl.sliloc = hst.olrilo
								AND sl.slord# = hst.olrord
								AND sl.slrel# = hst.olrrel
								AND sl.slitem = hst.olritm
								AND sl.slseq# = hst.olrseq)
						INNER JOIN shhead sh
							ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shcust = sl.slcust)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE hst.olrico = 1
							AND hst.olrilo = 50
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959   
							AND hst.olrtyp = ''''T''''
							AND sl.slxpal != 0
							AND sl.slcut != ''''Y''''
							AND  ux.usxemp#= 1579 
							/*AND hst.olrord = 848887*/
							AND sh.shviac NOT IN(''''1'''',''''6'''')					
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [RF WCall]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'RF WCall', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--***************************
--*     RF W/call COLUMN    *
--***************************
-- See 8.5 above
-- ** Get Line Items row ** 
-- have to sum per 5.2.1 above


delete WarehouseProductivity where Metric = ''RF W/Call''
go

insert WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

select Company, 
Location,
convert(datetime,RFDate,101) as RFSQLDate,
RFUser,
''RF W/Call'',
lineItemsForRF_WcallColumn


from openquery(GSFL2K,''
select Company, Location,RFDate,RFUser,
sum(countForRF_WCall) as lineItemsForRF_WcallColumn 
  from (
		select hst.olrico as Company,
				hst.olrilo as Location,
				hst.olrdat as RFDate,
				hst.olrusr as RFUser,
				count(*) as countForRF_WCall 
		  from oolrfuser hst
		 where hst.olrtyp = ''''S''''
		   and exists ( 
		               select 1
		                 from rfwillchsx wcc 
		                where hst.olrco = wcc.rfoco
		                  and hst.olrloc = wcc.rfoloc
		                  and hst.olrord = wcc.rfoord#
		                  and hst.olrrel = wcc.rforel#
		                  and hst.olrusr = wcc.rpuser
		              )
		  AND hst.olrdat >= ''''2011-10-15''''
		   and hst.olrtim >= 000001 
		   and hst.olrdat <= current_date 
		   and hst.olrtim <= 235959
		   
		   group by olrico, olrilo,olrdat,olrusr 

union all

		select hst.olrico as Company,
				hst.olrilo as Location,
				hst.olrdat as RFDate,
				hst.olrusr as RFUser,
				count(*) as countForRF_WCall 
		  from oolrfuser hst
		 where hst.olrtyp = ''''T''''
		   and exists ( 
		               select 1
		                 from rfwillchsx wcc 
		                where hst.olrco = wcc.rfoco
		                  and hst.olrloc = wcc.rfoloc
		                  and hst.olrord = wcc.rfoord#
		                  and hst.olrrel = wcc.rforel#
		                  and hst.olrusr = wcc.rpuser
		              )
		  AND hst.olrdat >= ''''2011-10-15''''
		   and hst.olrtim >= 000001 
		   and hst.olrdat <= current_date 
		   and hst.olrtim <= 235959 
		   
		   group by olrico, olrilo,olrdat,olrusr
		   
	  ) as allWillCallConsoleValuesToUseForLineItems

group by Company, Location,RFDate,RFUser	  

'')', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [XE Recv - xe_recv_cuts_no_plt_tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'XE Recv - xe_recv_cuts_no_plt_tag', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE cuts received ** No Pallet Tag**
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Rolls Recvd Non Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Rolls Recvd Non Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''X''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal = 0
						'')
GROUP BY usxemp# 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT itpco
							  ,itploc
							  ,ITICO
							  ,ITILOC
							  ,olrco
							  ,olrloc
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''X''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal = 0
							AND ux.usxemp# = 1641	
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [XE Recv -  xe_recv_cuts_plt_tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'XE Recv -  xe_recv_cuts_plt_tag', 
		@step_id=15, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE receive cuts by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Rolls Recv by Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, olrdat) AS PltCnt		
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Rolls Recv by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,itxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''X''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal != 0
							/*AND hst.olrord = 857136*/
						'')
GROUP BY usxemp# 
	,itxpal 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT itpco
							  ,itploc
							  ,olrco
							  ,olrloc
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959    
							AND hst.olrtyp = ''''X''''
							AND xe.itcut = ''''Y''''
							AND xe.itxpal != 0
							/*AND ux.usxemp# = 1991		*/
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [XE Recv - xe_recv_no_plt_tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'XE Recv - xe_recv_no_plt_tag', 
		@step_id=16, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE items received ** No Pallet Tag**
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Items Recvd Non Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT(olritm) AS Lines
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Items Recvd Non Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
							  ,olritm
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''X''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal = 0
						'')
GROUP BY usxemp# 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT itpco
							  ,itploc
							  ,ITICO
							  ,ITILOC
							  ,olrco
							  ,olrloc
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959  
							AND hst.olrtyp = ''''X''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal = 0
							AND ux.usxemp# = 1641	
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [XE Recv - xe_recv_plt_tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'XE Recv - xe_recv_plt_tag', 
		@step_id=17, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- XE receive Items by Pallet Tag	 
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Transfers Recevied by Pallet Tag Count
--
DELETE WarehouseProductivity 
WHERE Metric = ''XE Item Recv by Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, olrdat) AS PltCnt		
		,olrico 
		,olrilo 
		,convert(datetime,olrdat,101) as RFDate
		,olrusr 
		,''XE Item Recv by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT usxemp#
							  ,emname
							  ,itxpal
							  ,olrico
							  ,olrilo
							  ,olrdat
							  ,olrusr
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959    
							AND hst.olrtyp = ''''X''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal != 0
							/*AND hst.olrord = 857136*/
						'')
GROUP BY usxemp# 
	,itxpal 
	,emname
	,olrico
    ,olrilo
    ,olrdat
    ,olrusr
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.olrico 
	,CTE.olrilo 
	,CTE.RFDate
	,CTE.olrusr 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.olrico 
	,CTE.olrilo 
	,CTE.olrusr
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT itpco
							  ,itploc
							  ,olrco
							  ,olrloc
							  ,olrord
							  ,olrrel
							  ,olritm
							  ,olrseq
							  ,olrtyp
							  ,olrusr
							  ,itxpal
						FROM oolrfhst hst
						INNER JOIN transfer xe
							ON (hst.olrco = xe.itco
								AND hst.olrloc = xe.itloc
								AND hst.olrord = xe.itord#
								AND hst.olrrel = xe.itrel#
								AND hst.olritm = xe.ititem
								AND hst.olrseq = xe.itseq#
								AND hst.olrusr = xe.ituser)
						INNER JOIN userxtra ux
							ON hst.olrusr = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE xe.itpco = 1
							AND xe.itploc = 50	
						    AND hst.olrdat >= ''''2011-10-15''''
						    AND hst.olrtim >= 000001 
						    AND hst.olrdat <= current_date 
						    AND hst.olrtim <= 235959    
							AND hst.olrtyp = ''''X''''
							AND xe.itcut != ''''Y''''
							AND xe.itxpal != 0
							/*AND ux.usxemp# = 1991		*/
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Inv Move - inv_move_non_plt_items]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Inv Move - inv_move_non_plt_items', 
		@step_id=18, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- RF Move ofitems NON-Pallet tags
----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Inv Move Items Non Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT(iritem) AS Lines
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,''inv_move_non_plt_items'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irco = xe.itico
								AND ir.irloc = xe.itiloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND xe.itxpal = 0
							AND im.imfcrg != ''''Y''''
						'')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
	,CTE.RFDate 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT irco
							  ,irloc
							  ,irooco
							  ,iroolo
							  ,irord#
							  ,irrel#
							  ,iritem
							  ,irqty
							  ,irky
							  ,irsrc
							  ,iruser
							  ,itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irooco = xe.itco
								AND ir.iroolo = xe.itloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND xe.itxpal = 0
							AND im.imfcrg != ''''Y''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
						/*	AND ux.usxemp# = 1776	*/
							AND ir.iritem = ''''GR0440B''''
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Inv Move - inv_move_non_plt_rolls]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Inv Move - inv_move_non_plt_rolls', 
		@step_id=19, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- RF Move of rolls NON-Pallet tags
----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Inv Move Rolls by Non Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT(iritem) AS Lines
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,''Inv Move Rolls by Non Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irco = xe.itico
								AND ir.irloc = xe.itiloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND xe.itxpal = 0
							AND im.imfcrg = ''''Y''''
						'')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
	,CTE.RFDate 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT irco
							  ,irloc
							  ,irooco
							  ,iroolo
							  ,irord#
							  ,irrel#
							  ,iritem
							  ,irqty
							  ,irky
							  ,irsrc
							  ,iruser
							  ,itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irooco = xe.itco
								AND ir.iroolo = xe.itloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND xe.itxpal = 0
							AND im.imfcrg = ''''Y''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND ux.usxemp# = 1673	
						/*	AND ir.iritem = ''''GR0440B''''*/
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Inv Move - inv_move_plt_items]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Inv Move - inv_move_plt_items', 
		@step_id=20, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- Move items by pallet tag
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Inv Move Items by Plt Tag''
GO

 WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, irdate) AS PltCnt
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,''Inv Move Items by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
							  ,itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irco = xe.itico
								AND ir.irloc = xe.itiloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND xe.itxpal != 0
							AND im.imfcrg != ''''Y''''
						'')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
	  ,itxpal
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
	,CTE.RFDate 

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT irco
							  ,irloc
							  ,irooco
							  ,iroolo
							  ,irord#
							  ,irrel#
							  ,iritem
							  ,irqty
							  ,irky
							  ,irsrc
							  ,iruser
							  ,itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irooco = xe.itco
								AND ir.iroolo = xe.itloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date  
							AND ir.irsrc = ''''H''''
							AND xe.itxpal != 0
							AND im.imfcrg != ''''Y''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND ux.usxemp# = 1990	
						/*	AND ir.iritem = ''''GR0440B''''*/
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Inv Move - inv_move_plt_rolls]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Inv Move - inv_move_plt_rolls', 
		@step_id=21, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- Move rolls by pallet tag
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''Inv Move Rolls by Plt Tag''
GO
 
WITH CTE AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#, irdate) AS PltCnt
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,''Inv Move Rolls by Plt Tag'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
							  ,itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irco = xe.itico
								AND ir.irloc = xe.itiloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND ir.irqty > 0
							/*AND ir.ircust != 0*/
							AND xe.itxpal != 0
							AND im.imfcrg = ''''Y''''
						'')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
	  ,itxpal
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.PltCnt 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.PltCnt
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
	,CTE.RFDate 

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT irco
							  ,irloc
							  ,irooco
							  ,iroolo
							  ,irord#
							  ,irrel#
							  ,iritem
							  ,irqty
							  ,irky
							  ,irsrc
							  ,iruser
							  ,itxpal
						FROM itemrech ir
						INNER JOIN transfer xe
							ON (ir.irooco = xe.itco
								AND ir.iroolo = xe.itloc
								AND ir.irord# = xe.itord#
								AND ir.irrel# = xe.itrel#
								AND ir.iritem = xe.ititem
								AND ir.ircust = xe.itcust
								AND ir.irqty = xe.itqty)
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						     AND ir.irdate >= ''''2011-10-15''''
						    AND ir.irdate <= current_date 
							AND ir.irsrc = ''''H''''
							AND xe.itxpal != 0
							AND im.imfcrg = ''''Y''''
							AND ir.irqty > 0
						/*	AND ir.ircust != 0
							AND ux.usxemp# = 1709	
							AND ir.iritem = ''''GR0440B''''	*/
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Consolidations]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Consolidations', 
		@step_id=22, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--***************************
--*  CONSOLIDATIONS COLUMN  *
--***************************

-- ** Get Line Items row ** 


delete WarehouseProductivity where Metric = ''Consol''
go

insert WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
''Consol'',
lineItemsForInventoryConsolidationsColumn
from openquery(GSFL2K,''

select olrico, 
olrilo,
olrdat,
olrusr, 
count(*) as lineItemsForInventoryConsolidationsColumn
  from oolrfuser hst
 where hst.olrtyp = ''''J''''
 AND hst.olrdat >= ''''2011-10-15''''
   and hst.olrtim >= 000001 
   and hst.olrdat <= current_date 
   and hst.olrtim <= 235959 

group by olrico, olrilo,olrdat,olrusr
'')

', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Will Calls - Term Update]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Will Calls - Term Update', 
		@step_id=23, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--***************************
--*    WILL CALLS COLUMN    *
--***************************
-- See 8.9 above
-- ** Get Line Items row ** 

delete WarehouseProductivity where Metric = ''Term Update''
go

insert WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
''Will Calls'',
lineItemsForWillCallsColumn
 from openquery(GSFL2K,''

select olrico, 
olrilo,
olrdat,
olrusr,
count(*) as lineItemsForWillCallsColumn
  from oolrfuser hst
 where hst.olrtyp = ''''W''''
 AND hst.olrdat >= ''''2011-10-15''''
   and hst.olrtim >= 000001 
   and hst.olrdat <= current_date 
   and hst.olrtim <= 235959 
group by olrico, olrilo,olrdat,olrusr
'')


', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Inv Recv - recv_PO_non_Rolls]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Inv Recv - recv_PO_non_Rolls', 
		@step_id=24, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- Receipts of POs by Item Lines ** Non roll goods **
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''POs Recvd by Items''
GO

 WITH CTE AS (
	SELECT COUNT(iritem) AS Lines
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,''POs Recvd by Items'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
						FROM itemrech ir
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate  >= ''''2011-10-15'''' 
						    AND ir.irdate  <= current_date 
							AND ir.irsrc = ''''P''''
							AND ir.irdirs != ''''Y''''
							AND im.imfcrg != ''''Y''''
						'')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
	,CTE.RFDate 


----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT irco
							  ,irloc
							  ,iritem
							  ,irky
							  ,irsrc
							  ,iruser
						FROM itemrech ir
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate  >= ''''2011-10-15'''' 
						    AND ir.irdate  <= current_date 
							AND ir.irsrc = ''''P''''
							AND ir.irdirs != ''''Y''''
							AND im.imfcrg != ''''Y''''
							AND ux.usxemp# = 1501 
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Inv Recv - recv_PO_Rolls]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Inv Recv - recv_PO_Rolls', 
		@step_id=25, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-- Receipts of POs by Roll Good Lines
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
DELETE WarehouseProductivity 
WHERE Metric = ''POs Recvd by Rolls''
GO

 WITH CTE AS (
	SELECT COUNT(iritem) AS Lines
		,irco
		,irloc
		,convert(datetime,irdate,101) as RFDate
		,iruser
		,''POs Recvd by Rolls'' as [Desc]
		,usxemp# AS [User]
		,emname AS Name
	FROM OPENQUERY(GSFL2K,''SELECT iritem
							  ,irco
							  ,irloc
							  ,irdate
							  ,iruser
							  ,usxemp#
							  ,emname
						FROM itemrech ir
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate  >= ''''2011-10-15'''' 
						    AND ir.irdate  <= current_date 
							AND ir.irsrc = ''''P''''
							AND ir.irdirs != ''''Y''''
							AND im.imfcrg = ''''Y''''			
						'')
GROUP BY irco
	  ,irloc
	  ,irdate
	  ,iruser
	  ,usxemp#
	  ,emname
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
INSERT WarehouseProductivity (Company,Location,RFDate,RFUser,Metric,Value)

SELECT CTE.irco
	,CTE.irloc
	,CTE.RFDate
	,CTE.iruser 
	,CTE.[Desc] 
	,CTE.Lines 
FROM CTE
GROUP BY CTE.[User] 
	,CTE.Lines
	,CTE.Name
	,CTE.irco 
	,CTE.irloc 
	,CTE.iruser
	,CTE.[Desc]
	,CTE.RFDate
ORDER BY CTE.[User] 
		,CTE.RFDate

----------------------------------------------------------------------------------------
-- DETAILS CHECK BY USER EMP# or ORDER#
----------------------------------------------------------------------------------------
/*
SELECT *
FROM OPENQUERY(GSFL2K,''SELECT irco
							  ,irloc
							  ,iritem
							  ,irky
							  ,irsrc
							  ,iruser
						FROM itemrech ir
						INNER JOIN itemmast im
							ON ir.iritem = im.imitem
						INNER JOIN userxtra ux
							ON ir.iruser = ux.usxid
						INNER JOIN userfile uf
							ON ux.usxid = uf.usid
						INNER JOIN prempm em
							ON em.ememp# = 	ux.usxemp#	
						WHERE ir.irco = 1
							AND ir.irloc = 50
						    AND ir.irdate  >= ''''2011-10-15'''' 
						    AND ir.irdate  <= current_date 
							AND ir.irsrc = ''''P''''
							AND ir.irdirs != ''''Y''''
							AND im.imfcrg = ''''Y''''
							/*AND ux.usxemp# = 1626 */
						'')
*/
--------------------------------------------------------------------------------------------', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Clear Employee]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Clear Employee', 
		@step_id=26, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'truncate table warehouseusers', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Employees]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Employees', 
		@step_id=27, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/* ===========================================================================

   Build Employee Table

   =========================================================================*/

insert WarehouseUsers (EmployeeName,OLRUSR,EMEMP#)

select employeeName, userId, employeeNumber

from openquery(gsfl2k,''

select p.emname as employeeName, p.ememp# as employeeNumber, ux.usxid as userId
  from userxtra ux
  join prempm p
      on (ux.usxemp# = p.ememp#)

 '')', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Load Hours into Metric Table]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Hours into Metric Table', 
		@step_id=28, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity (Company,Location,RFDate,Dept,RFUser,Metric,Value)
select 
	case H.[Company Code]
		when ''zyb'' then 2
		else 1
	end,
	SUBSTRING(convert(varchar(10),H.Department),1,2),
	H.[Pay Date],
	RIGHT(H.Department,2),
	(select MAX(U.OLRUSR) from WarehouseUsers U where U.EMEMP# = CONVERT(decimal,H.Badge)),
	''Hours'',
	H.[Hours]
from WarehouseHours H
where h.[Pay Date] between ''10/15/2011'' and getdate()
and H.[Earnings Code] in (''OVERTIME'',''REGULAR'')
', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Concol]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Concol', 
		@step_id=29, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Consol( .4)'',w.Value*.4
from WarehouseProductivity W
where w.Metric = ''Consol''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Cuts]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Cuts', 
		@step_id=30, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Cuts (1.)'',w.Value*1
from WarehouseProductivity W
where w.Metric = ''Cuts''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Inv Move Items by Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Inv Move Items by Plt Tag', 
		@step_id=31, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Inv Move Items by Plt Tag (.25)'',w.Value*.25
from WarehouseProductivity W
where w.Metric = ''Inv Move Items by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Inv Move Rolls by Non Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Inv Move Rolls by Non Plt Tag', 
		@step_id=32, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Inv Move Rolls by Non Plt Tag (.35)'',w.Value*.35
from WarehouseProductivity W
where w.Metric = ''Inv Move Rolls by Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Inv Move Rolls by Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Inv Move Rolls by Plt Tag', 
		@step_id=33, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Inv Move Rolls by Plt Tag (.5)'',w.Value*.5
from WarehouseProductivity W
where w.Metric = ''Inv Move Rolls by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Inv Move Items Non Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Inv Move Items Non Plt Tag', 
		@step_id=34, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Inv Move Items Non Plt Tag (.4)'',w.Value*.4
from WarehouseProductivity W
where w.Metric = ''Inv Move Items Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - POs Recvd by Rolls]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - POs Recvd by Rolls', 
		@step_id=35, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted POs Recvd by Rolls (.5)'',w.Value*.5
from WarehouseProductivity W
where w.Metric = ''POs Recvd by Rolls''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - POs Recvd by Items]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - POs Recvd by Items', 
		@step_id=36, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted POs Recvd by Items (1.)'',w.Value*1
from WarehouseProductivity W
where w.Metric = ''POs Recvd by Items''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - RF W/Call]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - RF W/Call', 
		@step_id=37, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted RF W/Call (1.25)'',w.Value*1.25
from WarehouseProductivity W
where w.Metric = ''RF W/Call''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Rolls Moved]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Rolls Moved', 
		@step_id=38, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Rolls Moved (.9)'',w.Value*.9
from WarehouseProductivity W
where w.Metric = ''Rolls Moved''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Truck Item by Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Truck Item by Plt Tag', 
		@step_id=39, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Truck Item by Plt Tag (.35)'',w.Value*.35
from WarehouseProductivity W
where w.Metric = ''Truck Item by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Truck Items Non Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Truck Items Non Plt Tag', 
		@step_id=40, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Truck Items Non Plt Tag (.35)'',w.Value*.35
from WarehouseProductivity W
where w.Metric = ''Truck Items Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Truck Rolls by Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Truck Rolls by Plt Tag', 
		@step_id=41, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Truck Rolls by Plt Tag (.5)'',w.Value*.5
from WarehouseProductivity W
where w.Metric = ''Truck Rolls by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Truck Roll Counts Non Plt]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Truck Roll Counts Non Plt', 
		@step_id=42, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Truck Roll Counts Non Plt (.5)'',w.Value*.5
from WarehouseProductivity W
where w.Metric = ''Truck Roll Counts Non Plt''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Item Ship by Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Item Ship by Plt Tag', 
		@step_id=43, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Item Ship by Plt Tag (.25)'',w.Value*.25
from WarehouseProductivity W
where w.Metric = ''XE Item Ship by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Items Ship Non Plt Tag]    Script Date: 04/19/2012 13:42:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Items Ship Non Plt Tag', 
		@step_id=44, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Items Ship Non Plt Tag (.25)'',w.Value*.25
from WarehouseProductivity W
where w.Metric = ''XE Items Ship Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Rolls Ship by Plt Tag]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Rolls Ship by Plt Tag', 
		@step_id=45, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Rolls Ship by Plt Tag (.5)'',w.Value*.5
from WarehouseProductivity W
where w.Metric = ''XE Rolls Ship by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Rolls Ship Non Plt Tag]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Rolls Ship Non Plt Tag', 
		@step_id=46, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Rolls Ship Non Plt Tag (.5)'',w.Value*.5
from WarehouseProductivity W
where w.Metric = ''XE Rolls Ship Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Staged]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Staged', 
		@step_id=47, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Staged (1.)'',w.Value*1
from WarehouseProductivity W
where w.Metric = ''Staged''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Item Recv by Plt Tag]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Item Recv by Plt Tag', 
		@step_id=48, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Item Recv by Plt Tag (.15)'',w.Value*.15
from WarehouseProductivity W
where w.Metric = ''XE Item Recv by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Items Recvd Non Plt Tag]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Items Recvd Non Plt Tag', 
		@step_id=49, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Items Recvd Non Plt Tag (.4)'',w.Value*.4
from WarehouseProductivity W
where w.Metric = ''XE Items Recvd Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Rolls Recv by Plt Tag]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Rolls Recv by Plt Tag', 
		@step_id=50, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Rolls Recv by Plt Tag (.15)'',w.Value*.15
from WarehouseProductivity W
where w.Metric = ''XE Rolls Recv by Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - XE Rolls Recvd Non Plt Tag]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - XE Rolls Recvd Non Plt Tag', 
		@step_id=51, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted XE Rolls Recvd Non Plt Tag (.35)'',w.Value*.35
from WarehouseProductivity W
where w.Metric = ''XE Rolls Recvd Non Plt Tag''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Weighted Values - Will Calls]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Weighted Values - Will Calls', 
		@step_id=52, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity 
select w.Company,w.Location,w.RFDate,w.Dept,w.RFUser,''Weighted Term Upd (.05)'',w.Value*.05
from WarehouseProductivity W
where w.Metric = ''Will Calls''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Calculate Total RF Activity]    Script Date: 04/19/2012 13:42:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Calculate Total RF Activity', 
		@step_id=53, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert WarehouseProductivity (Company,Location,RFDate,Dept,RFUser,Metric,Value)
select p.Company,p.Location,p.RFDate,p.Dept,p.RFUser,''Total Activity'',SUM(p.Value)
from WarehouseProductivity P
where p.Metric like ''weight%''
group by p.Company,p.Location,p.RFDate,p.Dept,p.RFUser', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


