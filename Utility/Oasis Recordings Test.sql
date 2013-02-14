select *
from dbo.Recordings R
left join dbo.Calls c on r.CallID = c.ID
where r.Pathname like '%00VCEX%'

select * 
from dbo.Calls c
where c.PortNumber = 30
and c.CallID = '1:30:9321'

5733984

select * 
from dbo.Calls C
where c.ID = 5733984
where RowGUID = 
'24925194-29B2-43C2-ACF8-4FFCE5FB25FB'

select * from dbo.Configuration
select * from dbo.Nodes
select * from dbo.DeviceCallJoin