--begin tran T1;
 
insert into CustomerPriceHistory (custid,item,effectivedate,pricetype,price)

select lcus,litem,
CONVERT(datetime, CONVERT(VARCHAR(10), hisdate)) as EffectiveDate,
priceid,unitprice
from openquery(gsfl2k,'
select lcus,litem,hisdate,PRICEBAS,unitprice
from edi832hist
where lcus = ''1006826''
/* and hisdate = current_date */
and hisdate = ''2013-09-26''
')

--commit tran T1

/*
select lcus,litem,
CONVERT(datetime, CONVERT(VARCHAR(10), hisdate)) as EffectiveDate,
hisdate,
priceid,unitprice
from openquery(tsgsfl2k,'
select lcus,litem,hisdate,priceid,unitprice
from edi832hist
where lcus = ''1006826''

')
*/