select AccountNum,
PricingGroup,
Manufacturer,
StyleNum,
ManufStyleNum,
ManufStyleName,
SellingCompany,
Pid_StyleName,
Pid_MaterClass,
Pid_Collection,
Pid_Type

 
from EC_832Product
where ManufStyleName IN (select ManufStyleName from TAV_DupStyle)
order by ManufStyleName