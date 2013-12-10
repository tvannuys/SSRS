/* ACCENTS & INTERIORS INC   WOODINVILLE:  1023354, 1013354 

SR 16467

*/


select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  shco,shloc,shord#,shrel#
shinv#,
shidat,
sldate,
soldto.cmcust as SoldToCustID,
soldto.cmname as SoldToCust,
billto.cmcust as BillToCustID,
billto.cmname as BillToCust,

case

	when soldto.cmcust = ''1000265'' then ''KENT''
	when soldto.cmcust = ''1009785'' then ''TIGARD'' 
	when soldto.cmcust = ''1020256'' then ''SEATTLE''
	when soldto.cmcust = ''1020257'' then ''PORTLAND'' 
	when soldto.cmcust = ''1020258'' then ''VANCOUVER''
	when soldto.cmcust = ''1020259'' then ''TIGARD'' 
	when soldto.cmcust = ''1020260'' then ''CLACKAMAS''
	when soldto.cmcust = ''1020261'' then ''FIFE'' 
	when soldto.cmcust = ''1020262'' then ''REDMOND''
	when soldto.cmcust = ''1020263'' then ''EVERETT''
	when soldto.cmcust = ''1020264'' then ''HILLSBORO''
	else soldto.cmname
end as ReportCustomer, 

imfmcd as FamilyCode,
fmdesc as Family,
dvdiv as DivisionCode,
dvdesc as Division,

case
	when dvdiv in (6,7,8,9,10,13,41) then ''INSTALLATION ITEMS''
	else dvdesc
end as ReportDivision,

pcname as ProductCode,
slitem,
imdesc,
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
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno
		
where shidat >= ''1/1/2012''

and billto.cmcust in (''1023354'', ''1013354'')


')


/* 
where (
		(year(shline.sldate) = year(current_date - 1 month) or year(shline.sldate) = year(current_date - 1 month)-1)
				 and month(shline.sldate) <= month(current_date)-1)  /* last full month this year and last year */
*/

