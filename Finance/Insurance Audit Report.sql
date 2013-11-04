/* SR 15584  */

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  shinv# as InvoiceNbr,
shidat,
shotyp,
OTYDES,
soldto.cmzip,
billto.cmcust,
billto.cmname,
shsam4 as HeaderFreight,

SHEMDS,
shtotl


/* slesc2 as ItemFreight, */
/* sleprc as ExtendedPrice, */
/* SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost  */

from shhead
		
/*		left JOIN shline ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#)   */
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
/*		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM  */
		left join ootype on shotyp = OTYTYP
/* 		left join vendmast on slvend = vmvend  */
/*		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD   */
/*		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD   */
/*		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS   */
/*		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV   */
/*		left join salesman on shline.SLSLMN = salesman.smno  */
		
where shinv# in (''090965'',''092382'',''099529'',''138637'',''159491'',''178072'')

/* and shidat >= ''1/1/2013'' */
/* and shidat <= ''7/31/2013'' */

')


