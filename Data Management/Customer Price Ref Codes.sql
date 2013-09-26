select * from openquery (gsfl2k,'

select p.pecust as CustNum,
		p.peref# as PriceRefCode,
		c.cmname as PriceRefDesc
		
from pricexcp p
join custmast c on p.pecust = c.cmcust

where p.peref# <>''''

')