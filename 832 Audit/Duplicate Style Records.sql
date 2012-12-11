/* duplicate style records testing */

select Manufacturer, 
ManufStyleName,
PriceCode,
UnitPrice,
max(StyleNum),
COUNT(*)

from EC_832Product P

join ec_832ProdCost PC
	on P.SeqNum = PC.ProdSeqNum
	
group by Manufacturer, 
ManufStyleName,
PriceCode,
UnitPrice

having count(*) > 1

order by 1,2


--select COUNT(*) from ec_832product

/* no cost testing */

select  Manufacturer, 
StyleNum,
ManufStyleName,
c.SKU,
PriceCode,
pc.UOM,
UnitPrice,
pc.DroppedeDate,
pc.EffectiveDate

from EC_832Product P

join ec_832ProdCost PC 	on P.SeqNum = PC.ProdSeqNum
join ec_832Color C on C.ProdSeqNum = p.seqnum
	
where pc.UnitPrice = 0



