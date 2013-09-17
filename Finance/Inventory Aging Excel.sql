select OQ.ITEMNUMBER,
OQ.[DESCRIPTION],
OQ.COLOR,
OQ.[DROP],
OQ.STOCKING,
OQ.PRODUCTCODE,
OQ.ClassCode,
OQ.CLASS,
OQ.FAMILY,
OQ.DIVISION,
OQ.SampleFlag,
OQ.VENDOR,
OQ.IMPORTSTATUS,
OQ.BUYER,
OQ.COMPANY,
OQ.LOCATION,
OQ.LOCSTOCKITEM,
OQ.MASTERSTOCKITEM,

oq.MTDSales,
oq.LastMonthSales,
oq.MonthBeforeLastMonthSales as '-2 Months Sales',
oq.TwoMonthBeforeLastMonthSales as '-3 Months Sales',

oq.ThreeMonthSales as '3MonthSales',
oq.SixMonthSales as '6MonthSales',
oq.lyytdsales as 'LastYearYTDSales',

OQ.YTDSALES,
OQ.YTDCOGS,
OQ.YTDSALESQTY,
OQ.QTYONHAND,
OQ.QTYAVAILABLE,
OQ.TOTALVALUE,
OQ.AGE1 as '1-30 Days',
OQ.AGE2 as '31-60 Days',
OQ.AGE3 as '61-120 Days',
OQ.AGE4 as '121-239 Days',
OQ.AGE5 as '240-364 Days',
OQ.AGE6 as '365-719 Days',
OQ.AGE7 as '> 719 Days',

'Available Value' = 
	case oq.qtyonhand  
		when 0 then 0
		else round((OQ.TOTALVALUE/OQ.QTYONHAND)*OQ.QTYAVAILABLE,2)
	end,

'Non Committed Value' = 
	case oq.qtyonhand  
		when 0 then 0
		else round((OQ.TOTALVALUE/OQ.QTYONHAND)*(OQ.QTYONHAND-OQ.QtyOnOrder),2)
	end,

OQ.BuyerNumber,
OQ.DateLastCount

from openquery(gsfl2k,'

SELECT ITEMSTAT.ISITEM AS ItemNumber, 
ITEMMAST.IMDESC AS Description, 
ITEMMAST.IMCOLR AS Color, 
ITEMMAST.IMDROP AS Drop, 
ITEMMAST.IMSI AS Stocking, 
 pcdesc AS ProductCode, 

 itemmast.imcls# as ClassCode,
 ccdesc AS Class,  
 fmdesc AS Family,
 
dvdesc AS Division, 

case
	when ITEMMAST.IMFCRG = ''S''  then ''Y''
	else ''N''
end as SampleFlag,

vmname AS Vendor, 

case
	when itemmast.imclas = ''IM'' then ''Import''
	else ''Domestic''
end as ImportStatus,
	
byname AS Buyer, 
ITEMSTAT.ISCO AS Company, 
ITEMSTAT.ISLOC AS Location, 
ITEMBAL.IBPRIO AS LocStockItem, 
ITEMMAST.IMSI AS MasterStockItem, 

ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and slloc = ITEMSTAT.ISLOC
				AND (year(shline.sldate) = year(current_date)
				and month(shline.sldate) = month(current_date))
				),0) as MTDSales,

ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and slloc = ITEMSTAT.ISLOC
				AND (year(shline.sldate) = year(current_date - 1 month)
				and month(shline.sldate) = month(current_date)-1)
				),0) as LastMonthSales,

ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and slloc = ITEMSTAT.ISLOC
				AND (year(shline.sldate) = year(current_date - 2 month)
				and month(shline.sldate) = month(current_date)-2)
				),0) as MonthBeforeLastMonthSales,
				
ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and slloc = ITEMSTAT.ISLOC
				AND (year(shline.sldate) = year(current_date - 3 month)
				and month(shline.sldate) = month(current_date)-3)
				),0) as TwoMonthBeforeLastMonthSales,

ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 3 months and slloc = ITEMSTAT.ISLOC),0) as ThreeMonthSales,
ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 6 months and slloc = ITEMSTAT.ISLOC),0) as SixMonthSales,
ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and slloc = ITEMSTAT.ISLOC and 
		(sldate <= (current_date) - 1 year and year(sldate) = year(current_date) - 1) 
		),0) as LYYTDSales,

ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 12 months and slloc = ITEMSTAT.ISLOC),0) as YTDSales,
ifnull((select sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 12 months and slloc = ITEMSTAT.ISLOC),0) as YTDCOGS,
ifnull((select sum(SLBLUS) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 12 months and slloc = ITEMSTAT.ISLOC),0) as YTDSalesQty,
ITEMBAL.IBQOH AS QtyOnHand, 
ITEMBAL.IBQOO as QtyOnOrder,
IBQOH-IBQOO AS QtyAvailable, 
ITEMSTAT.ISVALU AS TotalValue,

ITEMSTAT.ISAGE1 AS Age1,
ITEMSTAT.ISAGE2 AS Age2, 
ITEMSTAT.ISAGE3 AS Age3, 
ITEMSTAT.ISAGE4 AS Age4,
ITEMSTAT.ISAGE5 AS Age5, 
ITEMSTAT.ISAGE6 AS Age6,
ITEMSTAT.ISAGE7 AS Age7,

itemmast.imbuyr as BuyerNumber,
itembal.IBLDLC as DateLastCount

FROM ITEMSTAT 
	JOIN ITEMMAST ON ITEMSTAT.ISITEM = ITEMMAST.IMITEM 
	JOIN ITEMBAL ON (ITEMSTAT.ISLOC = ITEMBAL.IBLOC
							AND	ITEMSTAT.ISCO = ITEMBAL.IBCO
							AND ITEMSTAT.ISITEM = ITEMBAL.IBITEM)
	left join family on itemmast.imfmcd = family.fmfmcd 
	left join prodcode on itemmast.imprcd = prodcode.pcprcd
	left join clascode on itemmast.imcls# = clascode.ccclas
	left join division on itemmast.imdiv = division.dvdiv
	left join vendmast on itemmast.imvend = vendmast.vmvend
	left join buyer on itemmast.imbuyr = buyer.bybuyr

WHERE ITEMSTAT.ISITEM <> ''WIWOODCOVESTICK''
And ITEMSTAT.ISITEM <> ''JSCCCC48''
AND (ITEMBAL.IBQOH + 
		ITEMSTAT.ISVALU + 
		ifnull((select sum(sleprc) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 12 months and slloc = ITEMSTAT.ISLOC),0) +
		ifnull((select sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) from shline where shline.slitem = ITEMSTAT.ISITEM and sldate >= current_date - 12 months and slloc = ITEMSTAT.ISLOC),0)
		) <> 0
		
and imvend in (010131,010133)

') OQ