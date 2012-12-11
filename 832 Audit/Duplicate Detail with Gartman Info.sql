select Manufacturer, 
ManufStyleName,
StyleNum,
PriceCode,
UnitPrice,
imprcd as 'Gartman Product Code',
P.SeqNum as ProductSeqNum

from EC_832Product P

join ec_832ProdCost PC
	on P.SeqNum = PC.ProdSeqNum

left join gartman.b107fd6e.gsfl2k.itemmast IM on IM.imitem = P.StyleNum
	
where ManufStyleName = 'WALL BASE RUBBER 6 TOE 100'''


--===================================

select Manufacturer, 
ManufStyleName,
StyleNum,
--imprcd as 'Gartman Product Code',
P.SeqNum as ProductSeqNum

from EC_832Product P

--left join gartman.b107fd6e.gsfl2k.itemmast IM on IM.imitem = P.StyleNum
	
where StyleNum = 'WIC81X001'