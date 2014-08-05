/* 


SR 23970

Created:  8/4/2014 - Thomas

 
*/


select *

from openquery(gsfl2k,'
select i1.imitem,
i1.imdesc,
i1.imcolr,
sum(SLECST) as SOCOGS,
ifnull((select sum(PBOQTY*i2.IMCOST)
		from poboline 
		join itemmast i2 on i2.imitem = pbitem
		where PBITEM = i1.imitem),0) as BOValue

from shline
LEFT JOIN ITEMMAST i1 ON SHLINE.SLITEM = i1.IMITEM 
		
where SLSDAT >= CURDATE() - 90 days
and i1.IMCLAS = ''IM''

group by i1.imitem,
i1.imdesc,
i1.imcolr

')


