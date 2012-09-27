--***************************
--*  CONSOLIDATIONS COLUMN  *
--***************************

-- ** Get Line Items row ** 


select olrico, 
olrilo,
convert(datetime,olrdat,101) as RFDate,
olrusr,
olritm,
olrqty,
olridk,
'Consol'/*,
lineItemsForInventoryConsolidationsColumn	*/
from openquery(GSFL2K,'

select olrico, 
olrilo,
olrdat,
olritm,
olrqty,
olridk,
olrusr /*, 
count(*) as lineItemsForInventoryConsolidationsColumn	*/
  from oolrfuser hst
 where hst.olrtyp = ''J''
 AND hst.olrdat >= ''2011-10-15''
   and hst.olrtim >= 000001 
   and hst.olrdat <= current_date 
   and hst.olrtim <= 235959 
	AND (hst.olrusr LIKE ''MATT%'' or hst.olrusr LIKE ''M1BON%'')
/*group by olrico, olrilo,olrdat,olrusr*/
')

