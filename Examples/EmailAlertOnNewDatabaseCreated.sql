
/* http://www.mssqltips.com/sqlservertip/2864/email-alerts-when-new-databases-are-created-in-sql-server/?utm_source=dailynewsletter&utm_medium=email&utm_content=headline&utm_campaign=20130328 */
--=======================================================================================================================
-- The following code below is the finished version of the DDL trigger that uses the basic DDL trigger above
-- and adds personalization about the server name and who created the database and sends an email to the DBA team. 
--=======================================================================================================================

USE master
GO

CREATE TRIGGER [ddl_trig_database]
ON ALL SERVER
FOR CREATE_DATABASE
AS
declare @results varchar(max)
declare @subjectText varchar(max)
declare @databaseName VARCHAR(255)
SET @subjectText = 'DATABASE Created on ' + @@SERVERNAME + ' by ' + SUSER_SNAME() 
SET @results = 
  (SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)'))
SET @databaseName = (SELECT EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]', 'VARCHAR(255)'))

--Uncomment the below line if you want to not be alerted on certain DB names
--IF @databaseName NOT LIKE '%Snapshot%'
EXEC msdb.dbo.sp_send_dbmail
 @profile_name = 'SQLAlerts',
 @recipients = 'SQLDBAGROUP@YOURDOMAIN.COM',
 @body = @results,
 @subject = @subjectText,
 @exclude_query_output = 1 --Suppress 'Mail Queued' message
GO
