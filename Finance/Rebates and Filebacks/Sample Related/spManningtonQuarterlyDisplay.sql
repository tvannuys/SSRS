USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spManningtonQuarterlyDisplay]    Script Date: 04/03/2014 07:17:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* spManningtonQuarterlyDisplay '08/01/2013','08/31/2013' */

CREATE proc [dbo].[spManningtonQuarterlyDisplay]

@FromDate varchar(10),
@ToDate varchar(10)

as

declare @sql varchar(3000)

set @sql = 'select * from openquery(gsfl2k,''
SELECT 
SHIDAT as Date,
VNCVCUST AS MMIRTLNum,
BillTo.CMNAME AS RetailerName,
shline.slinv# as InvoiceNumber,
shline.slitem as Product,
 slrecnbr as ReceiptNum,
(select max(IRINV#) from itemrech RH where RH.IRRECNBR = slrecnbr and rh.IRITEM = slitem and IRSRC = ''''P'''')
as ManningtonInvoice,
SHLINE.SLDESC as DisplayProvided,
SHLINE.SLBLUS as BillableUnitsShipped, 
SHLINE.SLECST as LandedCost,
itemmast.imrcst as NetCost,
shline.sleprc as Price,
''''50%'''' as PercentageOfDistSupport,
itemmast.imrcst * .5 as AmountAllocatedToDiscretionaryFund,
IMCOMMRES as CommResFlag
 

FROM SHLINE 
INNER JOIN CUSTMAST ON SHLINE.SLCUST = CUSTMAST.CMCUST 
INNER JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
						AND SHLINE.SLLOC = SHHEAD.SHLOC 
						AND SHLINE.SLORD# = SHHEAD.SHORD# 
						AND SHLINE.SLREL# = SHHEAD.SHREL# 
						AND SHLINE.SLINV# = SHHEAD.SHINV#)
LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM
left join ITEMXTRA on ITEMMAST.IMITEM = ITEMXTRA.IMXITM 
INNER JOIN CUSTMAST BillTo ON SHHEAD.SHBIL# = BillTo.CMCUST
left join vendcust on (billto.cmcust=VNCCUST and vncvend = ''''10131'''')  

WHERE SHHEAD.SHIDAT between' + '''''' + @FromDate + '''''' +
' and ' + '''''' + @ToDate + '''''' +

' AND shhead.shotyp = ''''DP''''
and itemmast.imvend in (''''10131'''', ''''10133'''') 
and IMCOMMRES <> ''''C''''

'')' 

exec(@sql)
GO

