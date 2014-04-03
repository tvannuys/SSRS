USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spManningtonQuarterlyDisplayFloor]    Script Date: 04/03/2014 07:18:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Display Floors */
/* spManningtonQuarterlyDisplayFloor '08/01/2013','08/31/2013' */

CREATE proc [dbo].[spManningtonQuarterlyDisplayFloor] 

@FromDate varchar(10),
@ToDate varchar(10)

as

declare @sql varchar(3000)

set @sql = 'select * from openquery(gsfl2k,''
SELECT
 BillTo.CMNAME AS RetailerName,
 VNCVCUST as ManningtonRetailerNum,
 SLINV# as RetailerInvoiceNum,
 SHIDAT as InvoiceDate,
 SHLINE.SLDESC as Product,
 shline.slitem as PatternNum,
 SLSRL1 as RollNum,
 slum2 as  SaleUOM,
 SHLINE.SLBLUS as Quantity,  
 /* SHLINE.SLEPRC as ExtendedSalePrice, */
 slpric as UnitSalePrice,
 I.imrcst as NetCost,
 imcommres as ResCommFlag
FROM SHLINE 
left JOIN CUSTMAST ON SHLINE.SLCUST = CUSTMAST.CMCUST 
left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
						AND SHLINE.SLLOC = SHHEAD.SHLOC 
						AND SHLINE.SLORD# = SHHEAD.SHORD# 
						AND SHLINE.SLREL# = SHHEAD.SHREL# 
						AND SHLINE.SLINV# = SHHEAD.SHINV#)
LEFT JOIN ITEMMAST I ON SHLINE.SLITEM = I.IMITEM 
LEFT join ITEMXTRA X ON I.IMITEM = X.IMXITM
left JOIN CUSTMAST BillTo ON SHHEAD.SHBIL# = BillTo.CMCUST
left join vendcust VC on (VC.vnccust = BillTo.CMCUST and vncvend = ''''10131'''')

WHERE SHHEAD.SHIDAT between ' + '''''' + @FromDate + '''''' +
' and ' + '''''' + @ToDate + '''''' +

' AND shhead.shotyp = ''''SR''''
and I.imvend in (''''10131'''', ''''10133'''')
and slpric <> 0
and imcommres <> ''''C''''
'') '

exec(@sql)
GO

