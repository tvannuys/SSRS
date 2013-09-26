select * from openquery (gsfl2k,'

select pecust as CustNum,
		peref# as PriceRefCode
		
from pricexcp

where peref# <>''''

')