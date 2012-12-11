select * from openquery(gsfl2k,'
select lprcd,litem,lmxprodsub,lprcdcat,priceid,lstylenum,ldesc,lstylename,lcolorname,unitprice,hasmult
from edi832hist
where lcus = ''1001786''
and ldesc like ''%LB #%''
and lprcdcat = ''97500000''

')

select * from openquery(gsfl2k,'

select *
from edi832hist
where litem like ''LASILIC62%''

and lcus = ''1001786'' 
/* and lprcd like ''52006%'' */
/* and hisdate = current_date */

')

-- FIND RECORD COUNTS BASED ON DATES
select * from openquery(gsfl2k,'

select hisdate, count(*)
from edi832hist
where lcus = ''1001786'' 
group by hisdate

')

--FIND PRODUCT CODES FOR A SPECIFIC DATE
select * from openquery(gsfl2k,'

select lvend,count(*)
from edi832hist
where lcus = ''4101786'' 
and hisdate in ( ''04/04/2012'', ''03/19/2012'')
group by lvend
')
