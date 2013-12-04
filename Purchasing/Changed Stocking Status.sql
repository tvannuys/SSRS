/* SR 16318  

Changed stocking status

Item Maintenance Changes within a single day - history

Before and After values

*/

select * from openquery(gsfl2k,'
select a.immcod,a.imitem, b.imsi as Before,a.imsi as After
from ITEMMAIN a
join itemmain b on (a.imitem = b.imitem and a.immusr = b.immusr and a.immtim = b.immtim)

where a.imsi <> b.imsi
and a.immact = ''C''
and a.immcod = ''IMB''

order by a.imitem, a.immcod desc

fetch first 100 rows only
')


