select * from openquery(gsfl2k,'
select cmcust,cmname,cmadr1,cmadr3
from custmast

where cmco = 2
and cmcust like ''4%''
order by cmname
')