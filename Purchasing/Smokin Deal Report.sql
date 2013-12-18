/* SR 16676 */

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  shco,shloc,shord#,shrel#,
shinv#,
shidat,
salesman.smno,
salesman.smname,
billto.cmcust,
billto.cmname,
slitem,
imdesc,
SLPRIC,
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
		
where shidat >= ''7/1/2013''
and shidat <= ''10/30/2013''

and slitem in (''HOBC376ANT'',
''QC7660PCC142BAM'',   
''QC7660PCC142CMS'',
''GR3002PROMO'',  
''GR3002SEC'',     
''GR3008PROMO'',  
''GR3008SEC'',    
''GR7012SEC'', 
''GR7012PROMO'',
''ARG4B052'', 
''ARG4B062'',  
''TAG4B052'', 
''TAG4B062'',
''BBCAOK95BIHDF'', 
''BBCAOK95HBHDF2'', 
''BBCAPC115ESHDF'',  
''BBCAPC95ESHDF'',    
''BBCAHI95ANHDF'')  
')


