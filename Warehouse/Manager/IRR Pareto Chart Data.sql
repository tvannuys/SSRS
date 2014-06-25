--======================================================================
-- Open orders Issue Codes
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
and l.olitem like ''IC%''
and right(trim(l.olitem),1) not in (''T'',''C'')
--and ohord# = 937142

order by ohco, ohloc, ohord#, ohrel#


')


--======================================================================
-- Invoiced orders Issue Codes
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
and l.slitem like ''IC%''
and right(trim(l.slitem),1) not in (''T'',''C'')

order by shco, shloc, shord#, shrel#

fetch first 100 rows only
')

--======================================================================
-- Open orders Reason Codes
--======================================================================

select CONVERT(datetime, CONVERT(VARCHAR(10), ohodat)) as IRRDate,
olitem as RootCauseCode,
imdesc as RootDesc,
olSRL1 as RootCauseProcessArea,
ohco as RootCauseCompany,
ohloc as RootCauseLocation,
ohord# as RootCauseOrder,
ohrel# as RootCauseRelease

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
		
		
where ohco=1
and soldto.cmcust = ''IRR1''
and l.olitem like ''RC%''

order by ohco, ohloc, ohord#, ohrel#


')

--======================================================================
-- Invoice orders - Reason Codes
--======================================================================


select CONVERT(datetime, CONVERT(VARCHAR(10), shodat)) as IRRDate,
slitem as RootCauseCode,
imdesc as RootDesc,
sLSRL1 as RootCauseProcessArea,
shco as RootCauseCompany,
shloc as RootCauseLocation,
shord# as RootCauseOrder,
shrel# as RootCauseRelease,
shidat as IRRCloseDate

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
sLSRL1,
shidat

from shline l
		
		left JOIN shHEAD h ON (l.slCO = h.shCO 
									AND l.slLOC = h.shLOC 
									AND l.slORD# = h.shORD# 
									AND l.slREL# = h.shREL# 
									and l.slinv# = h.shinv#
									) 
		left JOIN CUSTMAST billto ON h.shBIL# = billto.CMCUST 
		left join custmast soldto on h.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON l.sLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON l.sLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON l.sLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON l.sLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON l.sLDIV = DIVISION.DVDIV 
		left join salesman on l.sLSLMN = salesman.smno
		
where sHco=1
and soldto.cmcust = ''IRR1''
and l.slitem like ''RC%''
and shodat >= ''1/1/2014''

order by shco, shloc, shord#, shrel#

fetch first 100 rows only

')



