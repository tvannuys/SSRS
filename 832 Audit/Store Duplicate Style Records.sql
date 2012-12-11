/* store into TAV_DupStyle for join with other query to get detail 

	

*/

drop table TAV_DupStyle

select Manufacturer, 
ManufStyleName,
PriceCode,
UnitPrice,
COUNT(*) as NumberOfDups

into TAV_DupStyle

from EC_832Product P

join ec_832ProdCost PC
	on P.SeqNum = PC.ProdSeqNum
	
group by Manufacturer, 
ManufStyleName,
PriceCode,
UnitPrice

having count(*) > 1

order by 5 desc

select * from TAV_DupStyle