select * from openquery(gsfl2k,'
select imdesc, min(IMSDAT), count(*)
from itemmast m
join itemxtra x on m.imitem = x.imxitm

where imvend = ''10131''
and imdrop <> ''D''

group by imdesc

order by 1,3
')
