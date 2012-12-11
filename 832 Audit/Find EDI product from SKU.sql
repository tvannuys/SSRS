select Manufacturer, 
ManufStyleName,
c.Pid_ColorName,
c.Pid_ColorNum,
c.SKU,
PriceCode,
UnitPrice

from EC_832Product P

join ec_832ProdCost PC
	on P.SeqNum = PC.ProdSeqNum
	
join EC_832Color C on C.ProdSeqNum =P.SeqNum

where c.SKU = 'LASILIC6217'	
