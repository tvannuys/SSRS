USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[TA_Key_Products]    Script Date: 05/01/2014 13:17:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* SR 13449

Uses CUSTSEG table to identify key customers

Combine with results of a second query to 'Seed Customer List'

TA_Key_Products '01/01/2014','01/15/2014'

--==================================================
SR 22843 - For June, would you please drop Tru Loc and add Columbia ( a new LVT), per Danny�s request?



*/

ALTER proc [dbo].[TA_Key_Products] 

@StartDate varchar(10),
@EndDate varchar(10)

as

declare @sql varchar(max)

set @sql = 'select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,''
select  shco,shloc,shord#,shrel#,
shinv#,
shidat,
soldto.cmcust,
soldto.cmname,
smname,

case
	when csgcus is not null then ''''Key Customer''''
	else '''' ''''
end as KeyCustomer,

case 
	when pcprcd in (34056,34057, 34058) then ''''EvoStrand Bamboo''''
/*	when pcprcd = 22647 then ''''Quick Loc Bamboo''''   SR 24210  */
	
	when pcprcd = 13902 then ''''Odyssey''''
	when pcprcd = 13900 then ''''Catalina''''

	
/*	when pcprcd = 13700 then ''''Crystal Ridge''''       SR 24210  */
/* 	when pcprcd = 6392 then ''''Tru Loc''''              SR 22843  */
	when pcprcd = 82148 then ''''Columbia LVT''''
	when pcprcd = 82141 then ''''Bentley''''
	when pcprcd = 82142 then ''''Carrera''''
	when pcprcd = 82144 then ''''Nature''''
	
	when pcprcd = 33630 then ''''Olympic Solid Hardwood''''
	when pcprcd = 34500 then ''''Canyon Creek''''
	when pcprcd = 82140 then ''''Titan Grand Plank''''
	when pcprcd = 13622 then ''''Grand Mesa Plus''''
/*	when pcprcd = 13620 then ''''At Home Splendor''''     SR 24210  */
	when pcprcd = 13440 then ''''Lido''''
	when pcprcd = 13609 then ''''Savannah Laminate''''
	when pcprcd = 13646 then ''''Bourbon Street Laminate''''
	when pcprcd in (82145,82146) then ''''Bayport Plus''''
	when pcprcd = 4906 then ''''Wilderness LVT''''
	when pcprcd = 13597 then ''''Country Manor''''
	when pcprcd in (13592,84022,13594,13595) then ''''Ponderosa Villa''''
	
	when imvend = 22859 then ''''Bear Mountain''''
	when imvend = 24020 then ''''PureColor''''
	
	when pcprcd in (6307,6308,6309) then ''''LVS''''
	when pcprcd = 13990 then ''''Nat Urban Design''''
	when pcprcd = 14550 then ''''Development''''
	when pcprcd = 13950 then ''''Tandem''''
	when pcprcd = 13804 then ''''Loft''''
	
	else ''''Unknown Prod Code''''
	
end as ReportProductDesc,

SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
sleprc as ExtendedPrice

from CUSTMAST billto
		
		left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''''TK'''')
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
		
where (slprcd in (82148,82141,82142,82144,13622,13440,13609,13646,
					82145,82146,13597,13592,84022,13594,13595,13902,13900,
					13804, 13950, 14550, 13990, 6307, 6308, 6309)  
		or
	   slvend in (24020)
	   )
 
and shidat between ''''' + @StartDate + ''''' and ''''' + @EndDate + ''''' 
and soldto.cmco = 1

and smname not in (''''HOUSE'''',''''CLOSED ACCOUNTS'''',''''DEVELOPMENTAL/SALES MGRS'''',''''BLOW OUT ORDERS'''',
	''''PACMAT HOUSE'''',''''MARK CLEVENGER'''',''''INTERNET ORDERS'''',''''INACTIVE'''',''''GREG ROTHWELL'''',''''GARY CARSON'''')  


'')

union all

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,''
select  0 as shco,
0 as shloc,
0 as shord#,
0 as shrel#,
''''000000'''' as shinv#,''''' +
@StartDate + ''''' as shidat,
billto.cmcust,
billto.cmname,
smname,

case
	when csgcus is not null then ''''Key Customer''''
	else '''' ''''
end as KeyCustomer,

''''PlaceHolder'''' as ReportProductDesc,

0 as ExtendedCost,
0.01 as ExtendedPrice

from custmast billto
left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''''TK'''')
left join salesman on billto.CMSLMN = salesman.smno

where cmco = 1

and smname not in (''''HOUSE'''',''''CLOSED ACCOUNTS'''',''''DEVELOPMENTAL/SALES MGRS'''',''''BLOW OUT ORDERS'''',
	''''PACMAT HOUSE'''',''''MARK CLEVENGER'''',''''INTERNET ORDERS'''',''''INACTIVE'''',''''GREG ROTHWELL'''',''''GARY CARSON'''')  

order by cmname,smname

'')'

exec(@sql)
GO


