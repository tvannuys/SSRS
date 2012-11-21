select *
from openquery(GSFL2K,'
select u.usid,x.usxid, x.usxeml,p.emdept,p.emname
from userxtra x
left join prempm p on x.usxemp# = p.ememp#
left join userfile u on u.usid = x.usxid

order by usxid
')