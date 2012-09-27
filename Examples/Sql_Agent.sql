/* FROM>  http://www.mssqltips.com/sqlservertip/2561/querying-sql-server-agent-job-information/ */



/***************************************************************************************************************
SQL Server Agent Job Steps Execution Information
 
SQL Server Agent stores the history of the execution of each of the job steps in system tables in msdb database.
 
The following query gives us the details of last/latest execution of the job step. This information can also 
be found in the Job History/Log File Viewer windows in SSMS.
================================================================================================================
The following is a brief description of each of the fields returned from the above query:
 •[JobID]: A unique identifier for the SQL Server Agent job (GUID) to which the step(s) belongs.
 •[JobName]: Name of the SQL Server Agent job. 
 •[StepID]: A unique identifier for the SQL Server Agent Job Step (GUID). 
 •[StepNo]: Sequence number of the step representing the position of the step in the job.
 •[StepName]: Name of the SQL Server Agent Job Step. 
 •[LastRunStatus]: Status or Outcome of the step execution when the job/step executed last time.
 •[LastRunDuration (HH:MM:SS)]: Duration of the last run represented in Hours:Minutes:Seconds format.
 •[LastRunRetryAttempts]: Number of retry attempts made by SQL Server Agent during the last run of the job step.
 •[LastRunDateTime]: Date and time when the job step was last run.

*****************************************************************************************************************/

SELECT
    [sJOB].[job_id] AS [JobID]
    , [sJOB].[name] AS [JobName]
    , [sJSTP].[step_uid] AS [StepID]
    , [sJSTP].[step_id] AS [StepNo]
    , [sJSTP].[step_name] AS [StepName]
    , CASE [sJSTP].[last_run_outcome]
        WHEN 0 THEN 'Failed'
        WHEN 1 THEN 'Succeeded'
        WHEN 2 THEN 'Retry'
        WHEN 3 THEN 'Canceled'
        WHEN 5 THEN 'Unknown'
      END AS [LastRunStatus]
    , STUFF(
            STUFF(RIGHT('000000' + CAST([sJSTP].[last_run_duration] AS VARCHAR(6)),  6)
                , 3, 0, ':')
            , 6, 0, ':')
      AS [LastRunDuration (HH:MM:SS)]
    , [sJSTP].[last_run_retries] AS [LastRunRetryAttempts]
    , CASE [sJSTP].[last_run_date]
        WHEN 0 THEN NULL
        ELSE 
            CAST(
                CAST([sJSTP].[last_run_date] AS CHAR(8))
                + ' ' 
                + STUFF(
                    STUFF(RIGHT('000000' + CAST([sJSTP].[last_run_time] AS VARCHAR(6)),  6)
                        , 3, 0, ':')
                    , 6, 0, ':')
                AS DATETIME)
      END AS [LastRunDateTime]
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB]
        ON [sJSTP].[job_id] = [sJOB].[job_id]
ORDER BY [JobName], [StepNo]


/***************************************************************************************************************
SQL Server Agent Job Schedule Information
 
SQL Server allows creating schedules for performing various tasks at a specified date and time. 
This can be a one time schedule or a recurring schedule with or without an end date. 
Each schedule can be associated with one or more SQL Server Agent Jobs.
 
The following query gives us the list of schedules created/available in SQL Server and the details 
(Occurrence, Recurrence, Frequency, etc.) of each of the schedules.
==============================================================================================================
The following is a brief description of each of the fields returned from the above query:

 •[ScheduleID]: Unique identifier of the schedule (GUID). 
 •[ScheduleName]: Name of the schedule. SQL Server allows one schedule to be associated with more than one job.
 •[IsEnabled]: Indicator representing whether a schedule is enabled or disabled.
 •[ScheduleType]: The type of the schedule. 
 •[Occurrence]: Occurrence of the schedule like Daily, Weekly, Monthly, etc. 
 •[Recurrence]: Recurrence of the schedule like specific day(s), Specific Days of the Week, Number of weeks, etc.
 •[Frequency]: How frequently the job should run on the day(s) when it is scheduled to run such as: Occurs only once on the scheduled day(s), Occurs every 2 hours on the scheduled day(s) etc. between specified start and end times.
 •[ScheduleUsageStartDate]: Effective start date from when the schedule will be used.
 •[ScheduleUsageEndDate]: Effective end date after which the schedule will not be used.
 •[ScheduleCreatedOn]: Date and time when the schedule was created. 
 •[ScheduleLastModifiedOn]: Date and time when the schedule was last modified.

**************************************************************************************************************/

SELECT 
    [schedule_uid] AS [ScheduleID]
    , [name] AS [ScheduleName]
    , CASE [enabled]
        WHEN 1 THEN 'Yes'
        WHEN 0 THEN 'No'
      END AS [IsEnabled]
    , CASE 
        WHEN [freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN [freq_type] = 128 THEN 'Start whenever the CPUs become idle'
        WHEN [freq_type] IN (4,8,16,32) THEN 'Recurring'
        WHEN [freq_type] = 1 THEN 'One Time'
      END [ScheduleType]
    , CASE [freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
      END [Occurrence]
    , CASE [freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                    + ' week(s) on '
                    + CASE WHEN [freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                    + CASE WHEN [freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                    + CASE WHEN [freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                    + CASE WHEN [freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                    + CASE WHEN [freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                    + CASE WHEN [freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                    + CASE WHEN [freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) 
                     + ' of every '
                     + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
        WHEN 32 THEN 'Occurs on '
                     + CASE [freq_relative_interval]
                        WHEN 1 THEN 'First'
                        WHEN 2 THEN 'Second'
                        WHEN 4 THEN 'Third'
                        WHEN 8 THEN 'Fourth'
                        WHEN 16 THEN 'Last'
                       END
                     + ' ' 
                     + CASE [freq_interval]
                        WHEN 1 THEN 'Sunday'
                        WHEN 2 THEN 'Monday'
                        WHEN 3 THEN 'Tuesday'
                        WHEN 4 THEN 'Wednesday'
                        WHEN 5 THEN 'Thursday'
                        WHEN 6 THEN 'Friday'
                        WHEN 7 THEN 'Saturday'
                        WHEN 8 THEN 'Day'
                        WHEN 9 THEN 'Weekday'
                        WHEN 10 THEN 'Weekend day'
                       END
                     + ' of every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                     + ' month(s)'
      END AS [Recurrence]
    , CASE [freq_subday_type]
        WHEN 1 THEN 'Occurs once at ' 
                    + STUFF(
                 STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 2 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' 
                    + STUFF(
                   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 4 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' 
                    + STUFF(
                   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 8 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
      END [Frequency]
    , STUFF(
            STUFF(CAST([active_start_date] AS VARCHAR(8)), 5, 0, '-')
                , 8, 0, '-') AS [ScheduleUsageStartDate]
    , STUFF(
            STUFF(CAST([active_end_date] AS VARCHAR(8)), 5, 0, '-')
                , 8, 0, '-') AS [ScheduleUsageEndDate]
    , [date_created] AS [ScheduleCreatedOn]
    , [date_modified] AS [ScheduleLastModifiedOn]
FROM [msdb].[dbo].[sysschedules]
ORDER BY [ScheduleName]
