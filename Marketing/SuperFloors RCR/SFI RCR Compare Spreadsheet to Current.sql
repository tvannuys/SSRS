/*  

After spreadsheet is loaded to SFIRCRPricing table, run this to compare
	history of prices to what was in RCR
	

*/

select r.SKU,
r.Cut as RCRPrice,
h.lItem,
h.hisdate,
h.unitprice,
h.lsellunits

from SFIRCRPricing r
join openquery(gsfl2k, 'SELECT lcus,litem,hisdate,unitprice,lsellunits
  FROM edi832hist AS h
 WHERE hisdate =
       ( SELECT MAX(hisdate)
           FROM edi832hist
          WHERE lcus = h.lcus
          and litem = h.litem
          and lcus = ''1006826'' )
and lcus = ''1006826''

') h on r.SKU = h.lItem

where r.Cut <> h.unitPrice

order by 1,4

/*  
*
*
*	Find Drops
*
*
*/

select * 
from SFIRCRPricing r
where r.SKU in (select * from openquery(gsfl2k,'select imitem from itemmast where imdrop = ''D'' '))