
create proc spCustomerBillingCodes @CustID varchar(10)

as 

declare @sql varchar(max)

set @sql = 'select * from openquery (gsfl2k,''select cbcust as CustNum,
		cbblcd as BillCD,
		bcdesc as BillCDDesc
		
from custbill
	left join blcdmast on cbblcd = bcblcd

where cbcust = ' + '''''' + @CustID + ''''' ' + ''')'

exec(@sql)