/* 

Created By:  Thomas Van Nuys
Date Created: 

SR #25009


Qty Sold to get Avg Sale Price
Only items with sales in the last 3 years


imfact,
imfac2,
immd,
immd2,

*/

select OQ.*, 
case 
	when YTDQty <> 0 then YTDSales/YTDQty 
	else 0
end as AvgSalePrice

from openquery(gsfl2k,'
select imvend as Vendor, 
vmname as VendorName,
imdiv as Division,
dvdesc as DivisionDesc,
imfmcd as Family, 
fmdesc as FamilyDesc, 
imitem as Item, 
imdesc as ItemDesc, 
imcolr as Color, 

case
	when IMFCRG = ''S'' then ''Y''
	else ''N''
end as Sample,

case
	when imclas in (''IM'',''NL'') then ''Y''
	else ''N''
end as Import,

imsi as MasterStock,

imdrop as Drop,

IMP1 as Price1, 
imp2 as Price2, 
imp3 as Price3, 
imp4 as Price4, 
imp5 as Price5,

IMACST as AverageCost,

ifnull((select sum(SLBLUS)
		from shline sl 
		where sl.slitem = itemmast.imitem
		and year(SLDATE) = year(current_date)),0) as YTDQty,


ifnull((select sum(sleprc)
		from shline sl 
		where sl.slitem = itemmast.imitem
		and year(SLDATE) = year(current_date)),0) as YTDSales,

ifnull((select sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)
		from shline sl 
		where sl.slitem = itemmast.imitem
		and year(SLDATE) = year(current_date)),0) as YTDCOGS



from itemmast
left join itemxtra on imxitm = imitem
left join vendmast on imvend = vmvend
left join division on imdiv = dvdiv
left join prodcode on imprcd = pcprcd
left join family on imfmcd = fmfmcd
left join clascode cc on cc.ccclas = imcls#

where imitem in (select slitem from shline where year(sldate) >= (year(current_date)-3))


') OQ