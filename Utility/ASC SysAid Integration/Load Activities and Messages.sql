--truncate table SysAidMergedEmailActivity
--insert dbo.SysAidMergedEmailActivity

alter view SRActivities as

select 
'Activity' as ActType,
w.service_req_id as ActId,
w.to_time as ActTime,
w.[USER_NAME] as ActInitiator,
'Activity' as ActTitle,
w.[description] as ActBody
from sysaid.sysaid.dbo.work_report w
join sysaid.sysaid.dbo.service_req sr on sr.[Id] = service_req_id
--where sr.cust_text2 != ''

union all

select 
'Email' as ActType,  
srmsg.[Id] as ActId,
srmsg.msg_time as ActTime,
left(srmsg.from_user,50) as ActInitiator,
cast(srmsg.subject as nvarchar(100)) as ActTitle,
srmsg.msg_body as ActBody
from sysaid.sysaid.dbo.service_req_msg srmsg
join sysaid.sysaid.dbo.service_req sr on sr.[Id] = srmsg.[id]
where srmsg.method not in ('auto','esc')
--where sr.cust_text2 != ''

--select * from sysaid.sysaid.dbo.service_req_msg srmsg

