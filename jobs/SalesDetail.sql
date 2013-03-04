USE [msdb]
GO

/****** Object:  Job [Sales Detail]    Script Date: 03/04/2013 10:53:21 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 03/04/2013 10:53:21 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Sales Detail', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=3, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TASUPPLY\thomasv', 
		@notify_email_operator_name=N'Thomas', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Truncate Table]    Script Date: 03/04/2013 10:53:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Truncate Table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'truncate table CustomerSalesDetail', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Load Data]    Script Date: 03/04/2013 10:53:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Data', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert CustomerSalesDetail

--drop table CustomerSalesDetail

select InvoiceNbr, 
CONVERT(varchar(10),convert(datetime,shidat),101) AS InvoiceDate, 
CreditMemo, 
CustPO, 
Company, 
Loc, 
OrderNbr, 
SalesID,
SalesName,
BillToCustID,
BillToCustName, 
BillToCity,
BillToState,
SoldToCustID,
SoldToCustName,
SoldToCity,
SoldToState,

ShipToCustName,
ShipToCity,
ShipToState,
ShipToZip,

ItemNum, 
ItemDesc, 
VendorNum, 
VendorName,
ProductCode, 
ProductCodeDesc, 
FamilyCode, 
FamilyCodeDesc, 
ClassCode, 
ClassCodeDesc, 
Division, 
DivisionDesc, 
ExtendedPrice, 
ExtendedCost,
Profit

--into CustomerSalesDetail

		from openquery(gsfl2k,''

		SELECT SHLINE.SLINV# AS InvoiceNbr, 
		SHIDAT, 
		SHHEAD.SHCM AS CreditMemo, 
		SHHEAD.SHPO# AS CustPO, 
		SHLINE.SLCO AS Company, 
		SHLINE.SLLOC AS Loc, 
		SHLINE.SLORD# AS OrderNbr, 
		salesman.smno as SalesID,
		salesman.smname as SalesName,
		billto.CMCust AS BillToCustID, 
		billto.CMNAME AS BillToCustName, 
		Left(billto.CMADR3,23) AS BillToCity,
		Right(billto.CMADR3,2) AS BillToState,
		Soldto.cmname as SoldToCustName,
		Soldto.CMcust AS SoldToCustID, 
		Left(Soldto.CMADR3,23) AS SoldToCity,
		Right(Soldto.CMADR3,2) AS SoldToState,

		SHSTNM as ShipToCustName,
		Left(SHSTA3,23) AS ShipToCity,
		Right(SHSTA3,2) AS ShipToState,
		SHZIP as ShipToZip,
		
 		SHLINE.SLITEM AS ItemNum, 
		SHLINE.SLDESC AS ItemDesc, 
		SHLINE.SLVEND AS VendorNum, 
		vmname as VendorName,
		SHLINE.SLPRCD AS ProductCode, 
		PRODCODE.PCDESC AS ProductCodeDesc, 
		SHLINE.SLFMCD AS FamilyCode, 
		FAMILY.FMDESC AS FamilyCodeDesc, 
		SHLINE.SLCLS# AS ClassCode, 
		CLASCODE.CCDESC AS ClassCodeDesc, 
		SHLINE.SLDIV AS Division, 
		DIVISION.DVDESC AS DivisionDesc, 
		SLEPRC AS ExtendedPrice, 
		SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
		sleprc-(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) AS Profit,
		case
			when sleprc <> 0 then (sleprc-SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)/sleprc 
			else 0
		end as ProfitPerc

		FROM SHLINE 
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno

		WHERE vmvend <> 40000
		AND SHHEAD.SHIDAT >= ''''01/01/2011''''
		And SHHEAD.SHIDAT < current_date
		'')




', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Morning', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120410, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'238dd2b9-ebec-4728-befc-033679401ff9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


