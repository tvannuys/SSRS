/* 


Unused join

		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
*/


select SLINV#,	
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate,
CONVERT(datetime, CONVERT(VARCHAR(10), shodat)) as OrderDate,	
SHOTYP,	
SLCO,	
SLLOC,	
SLCUST,	
--CMNAME,	
--STATE,	
SLITEM,	
SLDESC,	
SLPRCD,	
SLPOR,	
SLPRIC,	
SLSCS4,	
EXTENDEDPRICE,	
EXTENDEDCOST,	
--EXTENDEDREBATE	
SLGL# as SALESGL,	
SLINVGL as INVENTORYGL,	
SLCOGSGL as COGSGL

from openquery(gsfl2k,'

select  shline.*,
shhead.*,

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
		
where year(shidat) in (2011)

and shco=2

fetch first 1000 rows only

')


