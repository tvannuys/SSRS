/* SR 15584  */

select InvoiceNbr,
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate,
OrderType,
OrderTypeDesc,
Company,
Location,
CustomerPO,
CustomerNbr,
CustomerName,
SubTotal,
FrtTaxEtc,
OrderTotal

from openquery(gsfl2k,'
select  shinv# as InvoiceNbr,
shidat,
shotyp as OrderType,
OTYDES as OrderTypeDesc,
shco as Company,
shloc as Location,
SHPO# as CustomerPO,
billto.cmcust as CustomerNbr,
billto.cmname as CustomerName,
SHEMDS as SubTotal,
shtotl - SHEMDS as FrtTaxEtc,
shtotl as OrderTotal


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
		
where shco = 3

and shidat >= ''11/1/2012'' 
and shidat <= ''10/31/2013'' 

')


