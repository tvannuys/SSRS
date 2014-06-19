create proc spCorlonSales as

--CONNECTION CORLON 6'

--drop table #TempConnectionCorlon

select SalesPerson,
Acct,
Customer,
PriceException,
City,
[State],
slprcd,
pcdesc,
ExtendedPrice,
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as OrderDate

into #TempConnectionCorlon

from openquery(gsfl2k,'
select  shidat,
slslmn || ''-'' || salesman.smname as SalesPerson,
soldto.cmcust as Acct,
trim(shcust) || ''-'' || soldto.cmname as Customer,
''N'' as PriceException,

substring(soldto.CMADR3,0,24) AS City, 
substring(soldto.CMADR3,24,2) AS State, 

slprcd,
pcdesc,

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
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		
where year(shidat) >= 2012
and shco=2
and slprcd = 70060
and salesman.smname <> ''CLOSED ACCOUNTS''

order by smname,
soldto.cmname

');

--=====================================================================

with cte (cmcust,cmname,CMSLMN, smname,cmadr3)
	as (select * from openquery(gsfl2k,'select cmcust,cmname,CMSLMN, smname,cmadr3
							from custmast 
							left join salesman on smno = cmslmn')
		)

insert #TempConnectionCorlon
select cast(oq.CMSLMN as varchar(10)) + '-' + oq.smname,
oq.cmcust,
rtrim(cmcust) + '-' + oq.cmname,
'N',
rtrim(substring(oq.CMADR3,0,24)), 
substring(oq.CMADR3,24,2),
(select max(slprcd) from #TempConnectionCorlon),
(select max(pcdesc) from #TempConnectionCorlon),
0,
d.DateEntry

from SalesProgramTracking t1
join DateList d on 1 = 1
left join cte oq on OQ.cmcust = t1.CustID

/* left join (select distinct salesperson, acct, CUSTOMER,
							PRICEEXCEPTION,CITY,[STATE],SLPRCD,PCDESC
			from #TempRej) oq


left join openquery(gsfl2k,'select c2.cmcust,c2.cmname,c2.CMSLMN, s2.smname,c2.cmadr3
							from custmast c2
							left join salesman s2 on s2.smno = c2.cmslmn') OQ
							
		on OQ.cmcust = t1.CustID
*/

where d.DateEntry <= dateadd(mm,1,GETDATE())
order by t1.CustID,d.DateEntry

update #TempConnectionCorlon
set PriceException = 'Y'
where Acct in (select CustId 
				from SalesProgramTracking 
				where SalesPerson = 'Dave Galeotti' 
				and ProgramDesc = 'CONNECTION CORLON')


select * from #TempConnectionCorlon where salesperson is not null

--drop table #TempConnectionCorlon

