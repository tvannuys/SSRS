

-- 09/06/2013 SR#13983 James Tuttle: Per Holiday exclude any Drops [AND ITEMMAST.IMDROP != ''D'']




ALTER proc [dbo].[spTrailing3Months]

@SeachTerm varchar(20) = '%'

as

declare @sql as varchar(max)

set @SeachTerm = upper(@SeachTerm)

set @sql = '

select * 
from openquery(GSFL2K,''

SELECT ITEMMAST.IMPRCD AS ProductCode,
ITEMMAST.IMITEM AS Item, 
ITEMMAST.IMDESC AS ItemDescription, 
ITEMMAST.IMCOLR AS Color, 

(select sum(slecst) from shline where itemmast.imitem = slitem and sldate between current_date - 90 days and  current_date) AS CostOfSales90Days,
(select sum(slecst) from shline where itemmast.imitem = slitem and sldate between current_date - 60 days and  current_date) AS CostOfSales60Days,
(select sum(slecst) from shline where itemmast.imitem = slitem and sldate between current_date - 30 days and  current_date) AS CostOfSales30Days,

/* (select sum(olecst) from oolbo where itemmast.imitem = olitem) as BackOrderCost, */

(select sum(olecst) from oolbo where ITEMBal.ibitem = olitem AND ITEMBal.ibloc = x.loc AND ITEMBal.obco = x.co ) as BackOrderCost,

itemxtra.imsearch as SearchWords,
division.DVDESC AS Division, 
itemmast.imfmcd as FamilyCode,
Family.fmdesc AS Family, 
VENDMAST.VMNAME AS Vendor, 
ITEMMAST.IMSI AS MasterStockItem, 
ITEMMAST.IMDROP AS DropFlag,
itemmast.imum1 as InventoryUOM,
itemmast.imum2 as SalesUOM,
itemmast.immd as IMMD,
itemmast.immd2 as IMMD2,
itemmast.imfact as IMFACT,
itemmast.imrpt2 as ReportCode2,
ibloc as Location,
lcrnam as LocationName,
(select SUM(ib.ibqoh * itemmast.imcost)from itembal ib where ITEMBal.ibco = ib.ibco and ITEMBal.ibloc = ib.ibloc) AS CostOnHand

/* ==========================================  This report version is set to look at costs instead of qtys	=============================	*/
/*ibqoh as OnHand,																															*/
/*ibqal as Allocated,																														*/
/*ibqoo as Committed,																														*/
/* ibqoh-ibqal-ibqoo as InvUOMAvailable,																									*/
/*	case																																	*/
/*			when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = '''' '''') then (IbQOH*itemmast.IMFACT)									*/
/*			when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = ''''D'''') then ((IbQOH*itemmast.IMFACT)/itemmast.IMFAC2)					*/
/*			else 0																															*/
/*		end as SalesUOMOnHand,																												*/
/*		case																																*/
/*			when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = '''' '''') then ((ibqoh-ibqal-ibqoo)*itemmast.IMFACT)						*/
/*			when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = ''''D'''') then (((ibqoh-ibqal-ibqoo)*itemmast.IMFACT)/itemmast.IMFAC2)	*/
/*			else 0																															*/
/*	end as SalesUOMAvail,																													*/
/*(select sum(olbluo) from oolbo where itemmast.imitem = olitem) as BackOrderQty,															*/
/*(select sum(plqord) from poline where itemmast.imitem = plitem) as POQty,																	*/
/*(select sum(SLBLUS) from SHLINE where slitem = itemmast.imitem and sldate between current_date - 30 days and current_date) as SalesQty30Days*/


FROM ITEMMAST
join VENDMAST ON VENDMAST.VMVEND = ITEMMAST.IMVEND
LEFT JOIN ITEMxtra ON ITEMxtra.IMXITM = ITEMMAST.IMITEM
/* LEFT JOIN ITEMMain ON ITEMMain.IMITEM = ITEMMAST.IMITEM */
LEFT JOIN ITEMBal ON ITEMBal.IbITEM = ITEMMAST.IMITEM
LEFT JOIN family ON Family.fmfmcd = ITEMMAST.IMFMCD
LEFT JOIN division ON division.DVDIV = ITEMMAST.IMDIV
left join location on (ibloc = lcloc and ibco = lcco)

where itemxtra.imsearch like ''''%TASMK%''''
and itemmast.IMFCRG <> ''''S''''
and (ITEMMAST.IMDESC like ''''%' + @SeachTerm + '%'''' or itemxtra.imsearch like ''''%' + @SeachTerm + '%'''' or ITEMMAST.IMCOLR like ''''%' + @SeachTerm + '%'''') 
AND ITEMMAST.IMDROP != ''''D''''


order by itemmast.imitem,ibloc

'')
'

--select @sql
exec (@sql)






GO


