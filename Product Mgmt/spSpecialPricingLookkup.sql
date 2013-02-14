--spSpecialPricingLookup '29180','2'

/* SR 6822

Created:  Thomas
Date: 1/15/2013

Used in SSRS report 'Special Pricing'.  Available for each company based
on parameter passed in @Company

*/
alter Proc spSpecialPricingLookup

@STP varchar(15),
@Company varchar(3)

as

declare @sql varchar(1000)

set @sql = 

'select * from openquery(gsfl2k,''
select olco,olloc,olord#,olrel#,olcust,
olitem,
imdesc,
OLQORD,olpric,OLSCS4,OLPROMO#
from ooline
join itemmast on olitem=imitem
where OLPROMO# = ''''' + @STP + '''''
and olco = ' + @Company +

''')'

--select(@sql)
exec(@sql)