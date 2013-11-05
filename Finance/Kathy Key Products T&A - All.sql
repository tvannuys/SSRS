/* SR 13449

Uses CUSTSEG table to identify key customers

Combine with results of a second query to 'Seed Customer List'

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
	when pcprcd in (34056,34057, 34058) then ''EvoStrand Bamboo''
	when pcprcd = 22647 then ''Quick Loc Bamboo''
	when pcprcd = 33630 then ''Olympic Solid Hardwood''
	when pcprcd = 34500 then ''Canyon Creek''
	when pcprcd = 82140 then ''Titan Grand Plank''
	when pcprcd = 13622 then ''Grand Mesa Plus''
	when pcprcd = 13620 then ''At Home Splendor''
	when pcprcd = 13440 then ''Lido''
	when pcprcd = 13609 then ''Savannah Laminate''
	when pcprcd = 13646 then ''Bourbon Street Laminate''
	when pcprcd in (82145,82146) then ''Bayport Plus''
	when pcprcd = 4906 then ''Wilderness LVT''
	when pcprcd = 13597 then ''Country Manor''
	when pcprcd in (13592,84022,13594,13595) then ''Ponderosa Villa''
	
	when imvend = 22859 then ''Bear Mountain''
	when imvend = 24020 then ''PureColor''
	
	else ''Unknown Prod Code''
	
end as ReportProductDesc,

SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
sleprc as ExtendedPrice

from CUSTMAST billto
		
		left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''TK'')
		left JOIN SHHEAD ON SHHEAD.SHBIL# = billto.CMCUST 
		left JOIN SHLINE ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left join salesman on shline.SLSLMN = salesman.smno
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		
where (slprcd in (34056,34057,34058,22647,33630,34500,82140,13622,13620,13440,13609,13646, 82145,82146,4906,13597,13592,84022,13594,13595) 
		or
	   slvend in (22859,24020)
	   )
and (billto.cmcust like ''1%'' or billto.cmcust like ''40%'')
 
and year(shidat) = year(current_date)
and month(shidat) <= 10


and shco=1

and smname not in (''HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'',''BLOW OUT ORDERS'',
	''PACMAT HOUSE'',''MARK CLEVENGER'',''INTERNET ORDERS'',''INACTIVE'',''GREG ROTHWELL'',''GARY CARSON'')  


')

--where shidat <= DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))


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

''ZeroDollar'' as ReportProductDesc,

0 as ExtendedCost,
0 as ExtendedPrice

from custmast billto
left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''TK'')
left join salesman on billto.CMSLMN = salesman.smno

where cmco = 1

and smname not in (''HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'',''BLOW OUT ORDERS'',
	''PACMAT HOUSE'',''MARK CLEVENGER'',''INTERNET ORDERS'',''INACTIVE'',''GREG ROTHWELL'',''GARY CARSON'')  

order by cmname,smname

')



