select Manufacturer, 
ManufStyleName,
PriceCode,
StyleNum,
UnitPrice

from EC_832Product P

join ec_832ProdCost PC
	on P.SeqNum = PC.ProdSeqNum
	
where StyleNum like '%'
and manufStyleName like 'SALTILLO GROUT 50#%'

order by unitprice


--delete ec_832product

select COUNT(*)
from EC_832Product


