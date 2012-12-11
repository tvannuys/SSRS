select * from openquery(gsfl2k,'
select prodcode.pcdesc,
litem,ldesc,lcolorname,unitprice,LPRUNITS
from edi832hist
join itemmast on imitem = litem
join prodcode on pcprcd = itemmast.imprcd
where lcus = ''1002179''

')