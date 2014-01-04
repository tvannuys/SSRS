/* 


Unused join

		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
*/

--drop table #TempSalesCommish

select slslmn, smname, sldiv, dvdesc, imitem, imdesc, ExtendedCost, ExtendedPrice, 
GETDATE() as ItemSetupDate,
0 as ItemAge

into #TempSalesCommish

from openquery(gsfl2k,'
select  slslmn,
salesman.smname,
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
and shco=1
and slslmn = 509

order by smname,
dvdesc,
imitem

')

--drop table #ItemAge

select * 
into #ItemAge
from openquery(gsfl2k,'
select imdesc, min(IMSDAT) as ItemSetupDate
from itemmast m
join itemxtra x on m.imitem = x.imxitm

group by imdesc
')

select * from #TempSalesCommish
select * from #ItemAge


update #TempSalesCommish 
set ItemSetupDate = a.ItemSetupDate
from #TempSalesCommish t1
join #ItemAge a on a.imdesc = t1.imdesc
where a.itemsetupdate <> '0001-01-01'

select *,DATEDIFF(m,ItemSetupDate,getdate()) as AgeMonth from #TempSalesCommish