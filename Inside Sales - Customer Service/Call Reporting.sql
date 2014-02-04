/* 

File from Fonality Report:  CDR reports, options inbound, outbound and InterOffice
	CDR_Report.csv \\tas3\Shared\Departmental Data\Sales Marketing\Customer Service\Fonality Call Logs
	
File from Fonality Report: ACD report:  Completed Calls :: Detail  
	acd_report.csv \\tas3\Shared\Departmental Data\Sales Marketing\Customer Service\Fonality Call Logs


Run CallLogImport Job in SQL

28800 seconds in an 8 hour day

*/


select a.CallDate, 'Queue' as CallType, a.Duration, a.Extension
from acd_report a
--where a.Extension = @Ext

union all

select c.calldate, c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c
where c.type = 'outbound'
--and c.src = @Ext
and c.src in (select distinct Extension from acd_report)


union all

select c.calldate, c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c
where c.type = 'inbound'
--and c.dst = @Ext
and c.dst in (select distinct Extension from acd_report)

union all

select c.calldate, 'Internal Out' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c

where c.type = 'ext2ext' 
and c.src <> c.dst
--and c.src = @Ext
and c.src in (select distinct Extension from acd_report)

union all

select c.calldate, 'Internal In' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c

where c.type = 'ext2ext' 
and c.src <> c.dst
--and c.dst = @Ext
and c.dst in (select distinct Extension from acd_report)