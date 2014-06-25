--======================================================================
-- Open orders Employee Codes
--======================================================================

select CONVERT(datetime, CONVERT(VARCHAR(10), ohodat)) as IRRDate,
olitem as IssueCode,
imdesc as IssueDesc,
OLSRL1 as IssueProcessArea,
ohco as IssueCompany,
ohloc as IssueLocation,
ohord# as IssueOrder,
ohrel# as IssueRelease

from openquery(gsfl2k,'
select  ohco,ohloc,ohord#,ohrel#,
ohodat,
ohvia,
soldto.cmzip,
billto.cmcust,
billto.cmname,
imfmcd,
dvdesc,
fmdesc,
olitem,
imdesc,
OLSRL1

from ooline l
		
		left JOIN ooHEAD h ON (l.olCO = h.ohCO 
									AND l.olLOC = h.ohLOC 
									AND l.olORD# = h.ohORD# 
									AND l.olREL# = h.ohREL# 
									) 
		left JOIN CUSTMAST billto ON h.ohBIL# = billto.CMCUST 
		left join custmast soldto on h.ohcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON l.oLITEM = ITEMMAST.IMITEM 
		left join vendmast on olvend = vmvend
		LEFT JOIN PRODCODE ON l.oLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON l.oLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON l.oLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON l.oLDIV = DIVISION.DVDIV 
		left join salesman on l.oLSLMN = salesman.smno
		
where OHco=1
and soldto.cmcust = ''IRR1''
and l.olitem like ''EC%''
and right(trim(l.olitem),1) = ''C''
--and ohord# = 937142

order by ohco, ohloc, ohord#, ohrel#


')


--======================================================================
-- Invoiced Orders Employee Codes
--======================================================================

select CONVERT(datetime, CONVERT(VARCHAR(10), shodat)) as IRRDate,
slitem as IssueCode,
imdesc as IssueDesc,
slSRL1 as IssueProcessArea,
shco as IssueCompany,
shloc as IssueLocation,
shord# as IssueOrder,
shrel# as IssueRelease

from openquery(gsfl2k,'
select  shco,shloc,shord#,shrel#,
shodat,
shvia,
soldto.cmzip,
billto.cmcust,
billto.cmname,
imfmcd,
dvdesc,
fmdesc,
slitem,
imdesc,
slSRL1

from shline l
		
		left JOIN shHEAD h ON (l.slCO = h.shCO 
									AND l.slLOC = h.shLOC 
									AND l.slORD# = h.shORD# 
									AND l.slREL# = h.shREL# 
									) 
		left JOIN CUSTMAST billto ON h.shBIL# = billto.CMCUST 
		left join custmast soldto on h.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON l.slITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON l.slPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON l.slFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON l.slCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON l.slDIV = DIVISION.DVDIV 
		left join salesman on l.slSLMN = salesman.smno
		
where shco=1
and soldto.cmcust = ''IRR1''
and l.slitem like ''EC%''
--and shord# = 937142

order by shco, shloc, shord#, shrel#

fetch first 100 rows only

')
