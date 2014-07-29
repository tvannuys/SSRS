alter proc spRunGL_Load as

EXEC MSDB.dbo.sp_start_job @Job_Name = 'Load GLBalances Table'