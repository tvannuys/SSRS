select * from openquery (gsfl2k,'

select	cbcust as CustNum,
		cbblcd as BillCD,
		bcdesc as BillCDDesc
		
from custbill
	left join blcdmast on cbblcd = bcblcd
	

		')