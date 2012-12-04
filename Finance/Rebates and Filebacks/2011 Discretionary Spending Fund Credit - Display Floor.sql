/* Display Floors */

select * from openquery(gsfl2k,'

SELECT 
 BillTo.CMNAME AS RetailerName,
 VNCVCUST as ManningtonRetailerNum,
 
 SLINV# as RetailerInvoiceNum,
 SHIDAT as InvoiceDate,
/*  BillTo.CMCUST AS MMIRTLNum,  */
 
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
left join vendcust VC on (VC.vnccust = BillTo.CMCUST and vncvend = ''10131'')

WHERE SHHEAD.SHIDAT between ''10/01/2012'' and ''11/30/2012''

AND shhead.shotyp = ''SR''
and I.imvend in (''10131'', ''10133'')
and slpric <> 0
and imcommres <> ''C''

')