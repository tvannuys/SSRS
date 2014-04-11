/* 

gdno as 'Number',
gdno2 as 'Vendor',
gdtemp as 'Temporary',
gdedat as 'Date Entered'


*/

select gdgl# as Account,
gdco as Company,
gdloc as Location,
gdsrc as 'Trans Source',
gddate as [Date],
GDJRFC as 'Jrnl Ref Code',
gdjrf# as 'Jrnl Ref #',
gddesc as 'Trans Desc',
gdamt as '$ Amount'

from openquery(gsfl2k,'
select * 
from gldetl
where GDACYR = 2011
and gdco = 2

')