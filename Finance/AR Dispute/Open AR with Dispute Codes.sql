/*  Will Crites  

Open AR with dispute codes

Get list of all invoices that have dispute codes on them
Get all transactions for those invoices (type 1 & 2)

*/

drop table #artemp

select * 
into #ARTemp
from openquery(gsfl2k,'
select oiinv#
from openitem
group by oiinv#
having sum(oiamt) = 0
')


select * from openquery(gsfl2k,'
select oicust,
cmname,
oiinv#,
oitype,
oicrcd,
acdesc,
OICOMT,
oiterm,
OIDSD1 as DueDate1,
OIDSD2 as DueDate2,
OIDSD3 as DueDate3,
oidate as OIDATE,
tmprox as TMPROX,
oiamt as OIAMT

from openitem
left join arterms on tmterm = oiterm
left join custmast on oicust=cmcust
left join ARCRCODE cr on cr.accode = openitem.oicrcd

 /* where oicrcd <> '' ''  */


')
where oiinv# not in (select oiinv# from #ARTemp)


