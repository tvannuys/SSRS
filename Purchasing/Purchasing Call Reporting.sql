/* 

Created By:  Thomas Van Nuys
Date Created: 8/19/2014

SR #24493

Run this after the TA CDR report data is loaded to SQL 
within the Call Center reporting process

Open a past version of the Excel Purchasing call report and
replace the Data with the results of the query below

*/


select c.calldate, 
c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c
where c.type = 'outbound'
and c.src in ('1616','1359','1015','1076','1014','1360','1361','1104','1027')
--and c.src = @Ext
--and c.src in (select distinct Extension from acd_report)


union all

select c.calldate, 
c.type as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c
where c.type = 'inbound'
and c.dst in ('1616','1359','1015','1076','1014','1360','1361','1104','1027')
--and c.dst = @Ext
--and c.dst in (select distinct Extension from acd_report)

union all

select c.calldate, 
'Internal Out' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.src as Extension

from CDR_Report c

where c.type = 'ext2ext' 
and c.src in ('1616','1359','1015','1076','1014','1360','1361','1104','1027')
and c.src <> c.dst
--and c.src = @Ext
--and c.src in (select distinct Extension from acd_report)

union all

select c.calldate, 
'Internal In' as CallType, 
datediff(second,'00:00:00',c.duration) as Duration,
c.dst as Extension

from CDR_Report c
where c.type = 'ext2ext' 
and c.dst in ('1616','1359','1015','1076','1014','1360','1361','1104','1027')
and c.src <> c.dst
--and c.dst = @Ext
--and c.dst in (select distinct Extension from acd_report)