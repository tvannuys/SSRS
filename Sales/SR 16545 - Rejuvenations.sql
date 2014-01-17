-- ==============================================================================================================

--REJUVENATIONS 2.0MM 6'

--drop table #TempRej

-- ==============================================================================================================

select *,
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as OrderDate

into #TempRej

from openquery(gsfl2k,'
select  shidat,
slslmn || ''-'' || salesman.smname as SalesPerson,
shcust as Acct,
trim(shcust) || ''-'' || soldto.cmname as Customer,
''N'' as PriceException,

substring(soldto.CMADR3,0,24) AS City, 
substring(soldto.CMADR3,24,2) AS State, 

slprcd,
pcdesc,

sleprc as ExtendedPrice

from CUSTMAST billto
		
		left JOIN shhead   ON SHHEAD.SHBIL# = billto.CMCUST  
		left JOIN shline ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		
where year(shidat) >= 2012
and shco=2
and slprcd = 70024
and salesman.smname <> ''CLOSED ACCOUNTS''

')


--=====================================================================

insert #TempRej
select d.DateEntry, oq.smname, t1.CustID, oq.cmname,
'N',
substring(oq.CMADR3,0,24),
substring(oq.CMADR3,24,2),
70024,
'REJUVENATIONS 2.0MM 6''',
0,
d.DateEntry

from SalesProgramTracking t1
join DateList d on 1 = 1

left join openquery(gsfl2k,'select c2.cmcust,c2.cmname,c2.CMSLMN, s2.smname,c2.cmadr3
							from custmast c2
							left join salesman s2 on s2.smno = c2.cmslmn') OQ
							
		on OQ.cmcust = t1.CustID

where d.DateEntry <= dateadd(mm,1,GETDATE())
order by t1.CustID,d.DateEntry

--=============================================================================

update #TempRej
set PriceException = 'Y'
where Acct in (select CustId 
				from SalesProgramTracking 
				where SalesPerson = 'Dave Galeotti' 
				and ProgramDesc = 'Rejuvenations')

		
select * from #TempRej

