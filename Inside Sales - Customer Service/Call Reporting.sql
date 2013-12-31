/* 

File CDR_Report.csv in Thomas' download folder

File acd_report.csv in Thomas' download folder


Must update acd_report table to set Extension field based on names

28800 seconds in an 8 hour day

*/

--update acd_report set Extension = '1025' where Agent = 'Carnahan, Jimmy'

declare @Ext as varchar(4) = '1025'


select a.CallDate, 'Queue' as CallType, a.Duration, a.Extension
from acd_report a
where a.Extension = @Ext

union all

select c.calldate, c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c
where c.type = 'outbound'
and c.src = @Ext

union all

select c.calldate, c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c
where c.type = 'inbound'
and c.dst = @Ext

union all

select c.calldate, 'Internal Out' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c

where c.type = 'ext2ext' 
and c.src <> c.dst
and c.src = @Ext

union all

select c.calldate, 'Internal In' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c

where c.type = 'ext2ext' 
and c.src <> c.dst
and c.dst = @Ext