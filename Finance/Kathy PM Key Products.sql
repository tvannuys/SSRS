select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  shco,shloc,shord#,shrel#
shinv#,
shidat,
sldate,
soldto.cmzip,
billto.cmcust,
billto.cmname,
smname,
dvdiv,
dvdesc,
imfmcd,
fmdesc,
pcprcd,
pcdesc,

case 
	when pcprcd = 22900 then ''Sentinel''
	when pcprcd = 55035 then ''Cork Ply''
	when pcprcd = 55045 then ''Seville''
	when pcprcd = 70911 then ''Promo Corlon''
	when pcprcd = 70534 then ''Main Street Tile''
	when pcprcd in (70775,70780) then ''BASE-ics 4” Wall Base''
	when pcprcd in (70086,70116,70121) then ''Linoleum ''
	when (pcprcd >= 52030 and pcprcd <= 52038) then ''Johnsonite TP Wall Base''
	when (pcprcd >= 52780 and pcprcd <= 52785) then ''Johnsonite TS Wall Base''
	when pcprcd = 32568 then ''Rapture Plank''
	when pcprcd = 32582 then ''Wood Classic''
	when pcprcd = 32556 then ''Brazos''
	when pcprcd = 32542  then ''Camden''
	when pcprcd = 32541 then ''Hathaway''
	when pcprcd = 32543 then ''Palisades''
	when pcprcd = 32604 then ''Rapid Clic''
	when pcprcd in (32512,32513) then ''Avante''
	when pcprcd in (32600,32602) then ''Accu Clic''
	
	else pcdesc
	
end as ReportProductDesc,

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
		
where (slprcd in (22900,55035,55045,70911,70534,70775,70780,70086,70116,70121,32568,32582,32556,32542,32541,32543,32512,32513,32604,32600,32602) 
		or slprcd between 52030 and 52038
		or slprcd between 52780 and 52785
	   )
/* and imfmcd not in (''B1'',''Y6'') */
and year(shidat) = 2013
and month(shidat) = 7
and shco = 2




')


