/* 

Commission Calculation Query

Change value in @ReportMonth and @ReportYear before running
		
*/

IF OBJECT_ID('tempdb..#ItemAge') IS NOT NULL
    DROP TABLE #ItemAge
    
truncate table TempSalesCommish

declare @AS400sql varchar(max)
declare @MSsql varchar(max)
declare @ReportMonth varchar(2)
declare @ReportYear varchar(4)

set @ReportMonth = '2'  
set @ReportYear = '2014'  -- use 4 digit year


set @AS400sql = '
select  shco,
slslmn,
salesman.smname,
billto.cmcust as BillTo,
soldto.cmcust,
soldto.cmname,
sldiv,
dvdesc,
imitem,
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
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno
		
where year(shidat) = ' + @ReportYear + '
and month(shidat) = ' + @ReportMonth + '

order by smname,
dvdesc,
imitem
'')
'

set @MSsql = 'insert TempSalesCommish 
select shco,slslmn, smname, BillTo,
cmcust,
cmname,
sldiv, dvdesc, imitem, imdesc, ExtendedCost, ExtendedPrice, 
GETDATE() as ItemSetupDate,
0 as ItemAge

from openquery(gsfl2k,''' + @AS400sql

exec(@MSsql)

--==============================================================================
--
--  STEP 2 
--
--==============================================================================

select * 
into #ItemAge
from openquery(gsfl2k,'
select imdesc, min(IMSDAT) as ItemSetupDate
from itemmast m
join itemxtra x on m.imitem = x.imxitm

group by imdesc
')

update #ItemAge
set ItemSetupDate = '2001-01-01'
where ItemSetupDate = '0001-01-01'



update TempSalesCommish 
set ItemSetupDate = a.ItemSetupDate
from TempSalesCommish t1
join #ItemAge a on a.imdesc = t1.imdesc
where a.itemsetupdate <> '0001-01-01'

/* moved to above previous step 

update #ItemAge
set ItemSetupDate = '2001-01-01'
where ItemSetupDate = '0001-01-01'
*/

/*================================================

Calculations and lookup to CommissionRate table

==================================================*/

-- Company 1
-- Based on Gross Sales

select t3.*,c.basedon,
case	
	when (cast(ItemSetupDate as DATE) < '1/1/2014' and BillTo <> '4100000') then t3.ExtendedPrice * c.Rate 
	when (BillTo = '4100000') then t3.ExtendedPrice * c.Rate * .5
	else t3.ExtendedPrice * .0125
end as Commission,

case	
	when cast(ItemSetupDate as DATE) < '1/1/2014' then 'Legacy'
	else 'New'
end as ProductAgeCategory

from TempSalesCommish t3
join CommissionRate c on (c.slslmn = t3.slslmn and c.sldiv = t3.sldiv)
where c.BasedOn = 'Gross Sales'
and t3.shco = 1

union all

-- Based on Gross Margin

select t3.*,c.basedon,
case	
	when (cast(ItemSetupDate as DATE) < '1/1/2014' and BillTo <> '4100000') then (t3.ExtendedPrice-t3.ExtendedCost) * c.Rate 
	when (BillTo = '4100000') then (t3.ExtendedPrice-t3.ExtendedCost) * c.Rate * .5

	else (t3.ExtendedPrice -t3.ExtendedCost) * c.Rate * 1
end as Commission,

case	
	when cast(ItemSetupDate as DATE) < '1/1/2014' then 'Legacy'
	else 'New'
end as ProductAgeCategory


from TempSalesCommish t3
join CommissionRate c on (c.slslmn = t3.slslmn and c.sldiv = t3.sldiv)
where c.BasedOn = 'Gross Margin'
and t3.shco = 1

union all

-- =============================================================================
--
-- Company 2    
-- Based on Gross Sales
--
-- =============================================================================

select t3.*,c.basedon,
case	
	when (cast(ItemSetupDate as DATE) < '1/1/2014' and BillTo <> '4100000') then t3.ExtendedPrice * c.Rate 
	when (BillTo = '4100000') then t3.ExtendedPrice * c.Rate * .5
	else t3.ExtendedPrice * c.Rate * 1
end as Commission,

case	
	when cast(ItemSetupDate as DATE) < '1/1/2014' then 'Legacy'
	else 'New'
end as ProductAgeCategory

from TempSalesCommish t3
join CommissionRate c on (c.slslmn = t3.slslmn and c.sldiv = t3.sldiv)
where c.BasedOn = 'Gross Sales'
and t3.shco in (2,3)

union all

-- =============================================================================
--
-- Company 2 - Based on Gross Margin
--
-- =============================================================================

select t3.*,c.basedon,
case	
	when (cast(ItemSetupDate as DATE) < '1/1/2014' and BillTo <> '4100000') then (t3.ExtendedPrice-t3.ExtendedCost) * c.Rate 
	when (BillTo = '4100000') then (t3.ExtendedPrice-t3.ExtendedCost) * c.Rate * .5

	else (t3.ExtendedPrice -t3.ExtendedCost) * c.Rate * 1
end as Commission,

case	
	when cast(ItemSetupDate as DATE) < '1/1/2014' then 'Legacy'
	else 'New'
end as ProductAgeCategory


from TempSalesCommish t3
join CommissionRate c on (c.slslmn = t3.slslmn and c.sldiv = t3.sldiv)
where c.BasedOn = 'Gross Margin'
and t3.shco in (2,3)


