/* 

File from Fonality Report:  CDR reports, options inbound, outbound and InterOffice
	CDR_Report.csv \\storage01\Shared\Departmental Data\Sales Marketing\Customer Service\Fonality Call Logs
	
File from Fonality Report: ACD report:  Completed Calls :: Detail  
	acd_report.csv \\storage01\Shared\Departmental Data\Sales Marketing\Customer Service\Fonality Call Logs

When a new agent needs to be tracked, edit the CallLogImport Job, last step, so the agent name is 
associated with the proper extension.

Run CallLogImport Job in SQL

28800 seconds in an 8 hour day

truncate table dbo.CDR_Report

*/

with CTE as (select distinct Extension, Agent from acd_report)

select a.CallDate, 'Queue' as CallType, a.Duration, a.Extension, a.Agent
from acd_report a
--where a.Extension = @Ext

union all

select c.calldate, c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension,
CTE.Agent

from CDR_Report c
join CTE on c.src = CTE.Extension
where c.type = 'outbound'
--and c.src = @Ext
--and c.src in (select distinct Extension from acd_report)


union all

select c.calldate, c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension,
CTE.Agent

from CDR_Report c
join CTE on c.dst = CTE.Extension
where c.type = 'inbound'
--and c.dst = @Ext
--and c.dst in (select distinct Extension from acd_report)

union all

select c.calldate, 'Internal Out' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension,
CTE.agent

from CDR_Report c
join CTE on c.src = CTE.Extension
where c.type = 'ext2ext' 
and c.src <> c.dst
--and c.src = @Ext
and c.src in (select distinct Extension from acd_report)

union all

select c.calldate, 'Internal In' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension,
CTE.Agent

from CDR_Report c
join CTE on c.dst = CTE.Extension
where c.type = 'ext2ext' 
and c.src <> c.dst
--and c.dst = @Ext
--and c.dst in (select distinct Extension from acd_report)