/* All customers, Company 2, not Closed, Salesperson assigned */

alter proc spCompany2AcctList @RepNum varchar(10) as

declare @sql varchar(max)

set @sql = 'select * from openquery (gsfl2k,''
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
	and cuclxclass <> ''''999''''
	and cmdelt <> ''''H''''
	and smno = ' + '''''' + @RepNum + '''''' + ''')'

exec (@sql)

