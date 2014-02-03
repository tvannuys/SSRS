/* 


Unused join

		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
		
drop table #ItemAge		
drop table #TempSalesCommish
		
*/

select shco,slslmn, smname, BillTo,
cmcust,
cmname,
sldiv, dvdesc, imitem, imdesc, ExtendedCost, ExtendedPrice, 
GETDATE() as ItemSetupDate,
0 as ItemAge

into #TempSalesCommish

from openquery(gsfl2k,'
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
		
where year(shidat) in (2013)
and month(shidat) = 12

order by smname,
dvdesc,
imitem

')



select * 
into #ItemAge
from openquery(gsfl2k,'
select imdesc, min(IMSDAT) as ItemSetupDate
from itemmast m
join itemxtra x on m.imitem = x.imxitm

group by imdesc
')


update #TempSalesCommish 
set ItemSetupDate = a.ItemSetupDate
from #TempSalesCommish t1
join #ItemAge a on a.imdesc = t1.imdesc
where a.itemsetupdate <> '0001-01-01'


update #ItemAge
set ItemSetupDate = '2001-01-01'
where ItemSetupDate = '0001-01-01'


/*================================================

Calculations and lookup to CommissionRate table

==================================================*/


-- Based on Gross Sales

select t3.*,c.basedon,
case	
	when (ItemSetupDate < '1/1/2014' and BillTo <> '4100000') then t3.ExtendedPrice * c.Rate 
	when (BillTo = '4100000') then t3.ExtendedPrice * c.Rate * .5
	else t3.ExtendedPrice * c.Rate *.8
end as Commission,

case	
	when ItemSetupDate < '1/1/2014' then 'Legacy'
	else 'New'
end as ProductAgeCategory

from #TempSalesCommish t3
join CommissionRate c on (c.slslmn = t3.slslmn and c.sldiv = t3.sldiv)
where c.BasedOn = 'Gross Sales'

union all

-- Based on Gross Margin

select t3.*,c.basedon,
case	
	when (ItemSetupDate < '1/1/2014' and BillTo <> '4100000') then (t3.ExtendedPrice-t3.ExtendedCost) * c.Rate 
	when (BillTo = '4100000') then (t3.ExtendedPrice-t3.ExtendedCost) * c.Rate * .5

	else (t3.ExtendedPrice -t3.ExtendedCost) * c.Rate *.8
end as Commission,

case	
	when ItemSetupDate < '1/1/2014' then 'Legacy'
	else 'New'
end as ProductAgeCategory


from #TempSalesCommish t3
join CommissionRate c on (c.slslmn = t3.slslmn and c.sldiv = t3.sldiv)
where c.BasedOn = 'Gross Margin'


