/* SR 16497 */

select * from openquery(gsfl2k,'

SELECT CUSTMAST.CMCUST AS CustNbr, 
CUSTMAST.CMNAME AS CustName, 
CUSTMAST.CMADR1 AS Addr1, 
CUSTMAST.CMADR2 AS Addr2, 
substring(CUSTMAST.CMADR3,0,24) AS City, 
substring(CUSTMAST.CMADR3,24,2) AS State, 
CUSTMAST.CMZIP AS ZipCode, 

b.CMADR1 AS BillToAddr1, 
b.CMADR2 AS BillToAddr2, 
substring(b.CMADR3,0,24) AS BillToCity, 
substring(b.CMADR3,24,2) AS BillToState, 
b.CMZIP AS BillToZipCode, 

CUSTMAST.CMPHON AS Phone, 
CUSTMAST.CMFAX AS FaxNbr, 
CUSTMAST.CMSLMN AS SalesmanNbr, 
SALESMAN.SMNAME AS RepName, 
CUSTMAST.CMATTN AS Contact, 
CUSTXTRA.CXE_MAIL AS EMail, 
custmast.CMFAX as Fax,
CEXURL as Website

FROM  CUSTMAST
left JOIN SALESMAN ON CUSTMAST.CMSLMN = SALESMAN.SMNO 
left JOIN CUSTXTRA ON CUSTMAST.CMCUST = CUSTXTRA.CXCUST
left JOIN CUSTEXTN ON CUSTMAST.CMCUST = CUSTEXTN.CEXCUST 

left join CUSTMAST b on CUSTMAST.CMBILL = b.cmcust

where custmast.cmco=1
and Custextn.cexclass not in (''201'',''202'')  /* Installers */
and CUSTMAST.CMLSAL >= ''1/1/2009''
and custmast.cmcust not like ''TRANSFER%''
and custmast.cmcust not in (''BLOWOUT'',
''BLOWOUTTA'',
''GREG50'',
''IRR'',
''IRR1'',
''SHOWROOM4'',
''SHOWROOM50'',
''SHOWROOM60'',
''1000001'')

order by custmast.cmname

')