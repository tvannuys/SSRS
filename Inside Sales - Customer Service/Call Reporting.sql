/* 


Must update acd_report table to set Extension field based on names

*/


select a.CallDate, 'Queue' as CallType, a.Duration, a.Extension
from acd_report a
where a.Extension = '1302'

union all

select c.calldate, c.type, 
--c.duration, 
--datediff(minute,'00:00:00',c.duration) as DurationMinutes,
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c
where c.type = 'outbound'
and c.src = '1032'

union all

select c.calldate, c.type, 
--c.duration, 
--datediff(minute,'00:00:00',c.duration) as DurationMinutes,
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c
where c.type = 'inbound'
and c.dst = '1032'