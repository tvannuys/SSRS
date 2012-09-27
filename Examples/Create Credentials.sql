
--Script #1 - Creating a credential to be used by proxy
USE MASTER
GO 
--Drop the credential if it is already existing 
IF EXISTS (SELECT 1 FROM sys.credentials WHERE name = N'jamest') 
BEGIN 
DROP CREDENTIAL jamest
END 
GO 
CREATE CREDENTIAL jamest
WITH IDENTITY = N'TASUPPLY\JamesT', 
SECRET = N'tasupply50' 
GO 

-----------------------------------------------------------------------------------------------------


--Script #2 - Creating a proxy account 
USE msdb
GO 
--Drop the proxy if it is already existing 
IF EXISTS (SELECT 1 FROM msdb.dbo.sysproxies WHERE name = N'SSISdailyHours') 
BEGIN 
EXEC dbo.sp_delete_proxy 
@proxy_name = N'SSISdailyHours' 
END 
GO 
--Create a proxy and use the same credential as created above 
EXEC msdb.dbo.sp_add_proxy 
@proxy_name = N'SSISdailyHours', 
@credential_name=N'jamest', 
@enabled=1 
GO 
----To enable or disable you can use this command 
--EXEC msdb.dbo.sp_update_proxy 
--@proxy_name = N'SSISProxyDemo', 
--@enabled = 1 --@enabled = 0 
--GO

------------------------------------------------------------------------------------------
--Script #3 - Granting proxy account to SQL Server Agent Sub-systems 
USE msdb
GO 
--You can view all the sub systems of SQL Server Agent with this command
--You can notice for SSIS Subsystem id is 11 
EXEC sp_enum_sqlagent_subsystems 
GO

--------------------------------------------------------------------------------------------

--Grant created proxy to SQL Agent subsystem 
--You can grant created proxy to as many as available subsystems 
EXEC msdb.dbo.sp_grant_proxy_to_subsystem 
@proxy_name=N'SSISdailyHours', 
@subsystem_id=11 --subsystem 11 is for SSIS as you can see in the above image 
GO 
--View all the proxies granted to all the subsystems 
EXEC dbo.sp_enum_proxy_for_subsystem 

---------------------------------------------------------------------------------------------

--Script #4 - Granting proxy access to security principals 
USE msdb
GO 
--Grant proxy account access to security principals that could be
--either login name or fixed server role or msdb role
--Please note, Members of sysadmin server role are allowed to use any proxy 
EXEC msdb.dbo.sp_grant_login_to_proxy 
@proxy_name=N'SSISdailyHours' 
,@login_name=N'TASUPPLY\JamesT' 
--,@fixed_server_role=N'' 
--,@msdb_role=N'' 
GO 
--View logins provided access to proxies 
EXEC dbo.sp_enum_login_for_proxy 
GO 

---------------------------------------------------------------------------------------------------------

----Script #5 - Granting proxy account to SQL Server Agent Sub-systems 
--EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'SSISdailyHours', 
--@step_id=1, 
--@cmdexec_success_code=0, 
--@on_success_action=1, 
--@on_success_step_id=0, 
--@on_fail_action=2, 
--@on_fail_step_id=0, 
--@retry_attempts=0, 
--@retry_interval=0, 
--@os_run_priority=0, @subsystem=N'SSIS', 
--@command=N'/FILE "C:\Package.dtsx" /CHECKPOINTING OFF /REPORTING E', 
--@database_name=N'master', 
--@flags=0, 
--@proxy_name = N'SSISdailyHours'; 