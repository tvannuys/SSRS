select * from openquery(gsfl2k,'
select m.gldesc, g.gdco,g.gdgl#, 
GDDESC as TranDesc,
month(gddate) as "GL Month", 
year(gddate) as "GL Year",
sum(gdamt) as Amount

from gldetl g
left join GLMASTGL m on m.glco = g.gdco    and m.glgl# = g.gdgl#

where gddate > current_date - 18 months
and gdjrfc = ''AC''
and gdgl# >= 600000

group by m.gldesc, g.gdco,g.gdgl#, gddesc,month(gddate), year(gddate)
')