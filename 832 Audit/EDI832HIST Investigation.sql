select * from openquery(gsfl2k,'

select ldesc,lcolorname,unitprice,LSELLUNITS,lprcdcat,LSIZECODE,LPRUNITS,PRICEBAS
/* select lprcd,litem,lmxprodsub,lprcdcat,priceid,lstylenum,ldesc,lstylename,lcolorname,unitprice,hasmult */

from edi832hist
left join itemmast on litem = imitem
left join vendmast on imvend = vmvend

where lcus = ''1010663''
and vmvend is null


order by 1,2,3 

/* and ldesc like ''%LB #%'' */
/* and lprcdcat = ''97500000'' */

')