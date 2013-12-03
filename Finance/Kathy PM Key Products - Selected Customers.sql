/* SR 13000

Uses CUSTSEG table to identify key customers

*/

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  shco,shloc,shord#,shrel#,
shinv#,
shidat,
soldto.cmcust,
soldto.cmname,
smname,

case
	when csgcus is not null then ''Key Customer''
	else '' ''
end as KeyCustomer,

case 
	when pcprcd = 22900 then ''BBoss Sentinel''
	when pcprcd = 13708 then ''Gala Lake Series''
	when pcprcd in (32607,32608) then ''Swiff Train Lancaster LVT''
	when pcprcd = 32542 then ''Swiff Train EW Camden''
	when pcprcd = 70024 then ''ARM Rejuvenations''
	when pcprcd in (70236,70237,70238,70239) then ''ARM Natural Creations''
	when pcprcd in (70020,70035) then ''ARM Medintech''	
	when pcprcd = 66053 then ''ARM Liberty 150 Glasback''
	when pcprcd = 13431 then ''Greenfield Aspen''	
	when pcprcd = 13430 then ''Greenfield Tahoe''	

	when imfmcd = ''Y2'' then ''Armstrong VCT''
	when imfmcd in (''Y9'',''Y!'') then ''Armstrong Linoleum''
	
	else pcdesc
	
end as ReportProductDesc,

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
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		left join salesman on shline.SLSLMN = salesman.smno
		left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''P('')
		
		
where (slprcd in (22900,13708,32607,32608,32542,70024,70236,70237,70238,70239,70020,70035,66053,13431,13430) 
		or
	   imfmcd in (''Y2'',''Y9'',''Y!'')
	   )
/* and imfmcd not in (''B1'',''Y6'') */
/* and (year(sldate)=year(current_date - 1 month) and month(sldate)=month(current_date)-1) -- REMOVED IN LIEU OF YTD DATA REQUEST FROM KATHY */

and year(shidat) = year(current_date)

and shco=2
and smname not in (''PACMAT HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'',''BLOW OUT ORDERS'')  

')

where shidat <= DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))


union all

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  0 as shco,
0 as shloc,
0 as shord#,
0 as shrel#,
''000000'' as shinv#,
current_date - 10 days as shidat,
billto.cmcust,
billto.cmname,
smname,

case
	when csgcus is not null then ''Key Customer''
	else '' ''
end as KeyCustomer,

''PlaceHolder'' as ReportProductDesc,

0 as ExtendedCost,
.01 as ExtendedPrice

from custmast billto
left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''P('')
left join salesman on CMSLMN = salesman.smno

where cmco = 2
and smname not in (''PACMAT HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'',''BLOW OUT ORDERS'')  

')

