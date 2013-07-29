USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spSalesStockQuery]    Script Date: 07/29/2013 10:14:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





alter proc [dbo].[spSalesStockQuery]

@SeachTerm varchar(20) = '%'

as

declare @sql as varchar(2500)

set @SeachTerm = upper(@SeachTerm)

set @sql = '

select * 
from openquery(GSFL2K,''

SELECT ITEMMAST.IMITEM AS Item, 
ITEMMAST.IMDESC AS ItemDescription, 
ITEMMAST.IMCOLR AS Color, 
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
ibqoh as OnHand,
ibqal as Allocated,
ibqoo as Committed,
ibqoh-ibqal-ibqoo as InvUOMAvailable,
case 
	when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = '''' '''') then (IbQOH*itemmast.IMFACT)
	when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = ''''D'''') then ((IbQOH*itemmast.IMFACT)/itemmast.IMFAC2)
	else 0
end as SalesUOMOnHand,
case 
	when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = '''' '''') then ((ibqoh-ibqal-ibqoo)*itemmast.IMFACT)
	when (itemmast.IMMD = ''''M'''' and itemmast.IMMD2 = ''''D'''') then (((ibqoh-ibqal-ibqoo)*itemmast.IMFACT)/itemmast.IMFAC2)
	else 0
end as SalesUOMAvail,
(select sum(olbluo) from oolbo where itemmast.imitem = olitem) as BackOrderQty,
(select sum(plqord) from poline where itemmast.imitem = plitem) as POQty,
(select sum(SLBLUS) from SHLINE where slitem = itemmast.imitem and sldate between current_date - 30 days and current_date) as SalesQty30Days


FROM ITEMMAST
join VENDMAST ON VENDMAST.VMVEND = ITEMMAST.IMVEND
LEFT JOIN ITEMxtra ON ITEMxtra.IMXITM = ITEMMAST.IMITEM
/* LEFT JOIN ITEMMain ON ITEMMain.IMITEM = ITEMMAST.IMITEM */
LEFT JOIN ITEMBal ON ITEMBal.IbITEM = ITEMMAST.IMITEM
LEFT JOIN family ON Family.fmfmcd = ITEMMAST.IMFMCD
LEFT JOIN division ON division.DVDIV = ITEMMAST.IMDIV
left join location on (ibloc = lcloc and ibco = lcco)

where itemxtra.imsearch like ''''%TASMK%''''
and (ITEMMAST.IMDESC like ''''%' + @SeachTerm + '%'''' or itemxtra.imsearch like ''''%' + @SeachTerm + '%'''' or ITEMMAST.IMCOLR like ''''%' + @SeachTerm + '%'''') 

order by itemmast.imitem,ibloc

'')
'

--select @sql
exec (@sql)




GO


