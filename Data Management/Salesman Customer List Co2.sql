select * from openquery (gsfl2k,'
select	smno as RepNum,	
		smname as RepName,
		cmcust as CustNum,
		cmname as CustName,
		left(cmadr3,23) as City,
		right(cmadr3,2) as State
		
		
		
from custmast 
	left join salesman on smno=cmslmn
	left join cucl2xref on cuclxcust=cmcust
where cmco=2
	and smno is not null	
	and cuclxclass <> ''999''
	and cmdelt <> ''H''


')