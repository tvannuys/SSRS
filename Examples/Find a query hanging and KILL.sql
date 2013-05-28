SELECT sqltext.TEXT,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time /1000 as 'Elapsed time, seconds',
req.total_elapsed_time /1000 / 60 as 'Elapsed time, minutes'
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext;



/****** Following is the t_sql I usually use to find a specific session (which is creating problem and need to be killed immediately) ******/
--SELECT DISTINCT
--        name AS database_name, 
--        session_id,
--        host_name,
--        login_time,
--        login_name,
--        reads,
--        writes
--FROM    sys.dm_exec_sessions
--        LEFT OUTER JOIN sys.dm_tran_locks ON sys.dm_exec_sessions.session_id = sys.dm_tran_locks.request_session_id
--        INNER JOIN sys.databases ON sys.dm_tran_locks.resource_database_id = sys.databases.database_id
--WHERE   resource_type <> 'DATABASE'
--AND name ='SQL01'
--ORDER BY name



/***** Kill the query ID ******/
--Kill 75;
--GO