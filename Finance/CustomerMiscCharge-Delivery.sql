/* 

Gartman screens:  Main, 12-Order Entry, 14-Pricing Menu, 1. Pricing File Maintenance Menu,  6. Customer Misc Charges 

*/

alter proc spCustDeliveryChargeOverride '1041292'

@CustID as varchar(15)

as

declare @sql varchar(2000)

set @sql = 'select * from openquery(gsfl2k,''
select cccust,
CCSEQ# as Sequence,
CCSDAT as StartDate,
CCEDAT as EndDate,

case
	when ccviac <> '''' '''' then videsc
	else ''''All Other''''
end as ShipVia,



CCSTY1 as DelChargeType,
CCSAM1 as DeliveryCharge,

case
	when CCSTY1 = ''''*'''' then 0
	when (CCSTY1 = ''''$'''' and  CCSAM1 <> 0) then CCSAM1
	when (CCSTY1 = ''''$'''' and  CCSAM1 = 0) then (select route.rtamt from route join custmast on custmast.cmdrt1=route.rtrout and custmast.cmcust=cccust) 
	
end as EffectiveCharge,

CCLCUS as LastChangeUser,
CCLCDT as LastChangeDate

from CUSTMSCG
left join SHIPVIA on vicode = ccviac

where (cccust like ''''1%'''' or cccust like ''''4%'''' or cccust like ''''6%'''')
and cccust = ' + '''''' + @CustID + '''''' + '

order by cccust,ccseq#

'') 

'

exec(@sql)