/* 

Created By:  Thomas Van Nuys
Date Created: 9/19/2014

SR #25578

*/


select *,
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as OrderDate

from openquery(gsfl2k,'

select  
soldto.cmname as SalesPerson,
shidat,
vmname as Vendor,
dvdesc as Division,
pcdesc as ProductCode,
slitem as Item,
imdesc as ItemDesc,
imcolr as ItemColor,

SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
sleprc as ExtendedPrice

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		left join salesman on shline.SLSLMN = salesman.smno
		left join vendmast on slvend = vmvend
		
where year(shidat) in (2014)

and soldto.cmcust  in (''1000121'',''1000214'',''6101245'',''1002135'',
					''6100500'',''6142088'',''1002118'',''1002001'',
					''1002101'',''1002100'',''4102100'',''6102100'',
					''1001178'',''4101178'',''6101178'')
order by smname,
dvdesc

')


