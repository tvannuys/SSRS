with ItemMast_CTE (imitem,imprcd)
as (
	select * from openquery(gsfl2k,'select imitem, imprcd from itemmast')
	)

select Manufacturer, 
ManufStyleName,
PriceCode,
UnitPrice,
--StyleNum,
imprcd as 'Gartman Product Code',
COUNT(*) as NumOfDups

from EC_832Product P

join ec_832ProdCost PC
	on P.SeqNum = PC.ProdSeqNum

left join ItemMast_CTE I on I.imitem = P.StyleNum

group by Manufacturer, 
ManufStyleName,
PriceCode,
UnitPrice,
--StyleNum,
imprcd

having count(*) > 1
	
order by 6 desc, 1, 2


--===================================

