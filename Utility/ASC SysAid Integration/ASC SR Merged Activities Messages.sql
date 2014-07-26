/*

SR Project
SR Status

Sub reports for calls and activities

*/

select g.[ASC],

case g.[Type]
	when 'Q' then 'Quote'
	when 'S' then 'Support'
	else g.[Type]
end as ASCType,

case g.Priority
	when 0 then 'None'
	when 1 then 'High'
	when 2 then 'Medium'
	when 3 then 'Low'
	else 'Unknonwn'
end as ASC_Priority,

case g.[Status]
	when 'A' then 'Assigned'
	when 'C' then 'Closed'
	when 'H' then 'On Hold'
	when 'I' then 'In Progress'
	when 'O' then 'Open'
	when 'Q' then 'Quoated'
	when 'R' then 'Report to Cust'
		else 'Unknonwn'
end as ASC_Status,

g.[Date Reported],
g.[Description],
g.Comments,
g.[CSR Name],
g.[Assigned To],
g.[Reported By],

pj.title as Project_Title,
sr.[Id] as SR_ID,
sr.title as SR_Title,
st.[value_caption] as SR_Status,
sr.responsibility as SR_Responsibility,
sr.notes as SR_Notes,
(select MAX(to_time) from sysaid.sysaid.dbo.work_report where service_req_id = sr.[Id]) as LastSRActivity,
(select MAX(msg_time) from sysaid.sysaid.dbo.service_req_msg where id = sr.[Id]) as LastSRMessage,
a.ActTime,
a.ActType,
a.ActInitiator,
a.ActTitle,
a.ActBody


/*
sra.to_time as ActivityDate,
sra.user_name as ActivityUser,
sra.description as ActivityDescription,
srmsg.msg_time as MsgTime,
srmsg.from_user as MsgFrom,
srmsg.to_user as MsgTo,
srmsg.subject as MsgSubject,
srmsg.msg_body as MsgBody
*/

from GartmanASC g
left join SYSaid.sysaid.dbo.service_req sr on sr.cust_text2 = cast(g.[ASC] as varchar(255))
left join sysaid.[sysaid].[dbo].[cust_values] st on (sr.[status] = st.value_key and st.list_name = 'status')
left join sysaid.sysaid.dbo.project pj on sr.project_id = pj.id
left join SysAidMergedEmailActivity a on sr.[id] = a.ActId

order by a.ActTime

/*

left join sysaid.sysaid.dbo.work_report sra on sra.service_req_id = sr.[Id]
left join sysaid.sysaid.dbo.service_req_msg srmsg on sr.[id] = srmsg.[Id]

*/

--  dbo.work_report = SR Activities


--  dbo.service_req_msg = SR Messages

