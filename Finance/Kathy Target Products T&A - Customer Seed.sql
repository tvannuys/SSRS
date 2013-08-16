select * from openquery(gsfl2k,'
select cmcust,
cmname,
smname

from custmast
left join salesman on cmSLMN = smno

where (cmcust like ''1%'' or cmcust like ''40%'')
 and smname is not null  
 and smname not in (''HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'') 
 
 order by cmcust 
')
						
