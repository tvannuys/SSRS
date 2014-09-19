/* 


Created By:  Thomas Van Nuys
Date Created: 9/12/2014

SR #25320


Unused join

		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
*/


select *,
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as OrderDate

from openquery(gsfl2k,'

select  slslmn,
salesman.smname as SalesPerson,
billto.cmcust as Acct,
billto.cmname as BillToCustomer,
soldto.cmname as SoldToCustomer,
shidat,
sldiv,
dvdesc as Division,

slprcd,
pcdesc as ProductCode,

sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as ExtendedCost,
sum(sleprc) as ExtendedPrice


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
		
where year(shidat) in (2014)
and month(shidat) in (9)

and shco=2

group by slslmn,
salesman.smname,
billto.cmcust,
billto.cmname,
soldto.cmname,
shidat,
sldiv,
dvdesc,

slprcd,
pcdesc

')


