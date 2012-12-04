/* Displays */

select * from openquery(gsfl2k,'

SELECT 
 SHIDAT as Date,
 BillTo.CMCUST AS MMIRTLNum,
 BillTo.CMNAME AS RetailerName,
 shline.slinv# as InvoiceNumber,
 shline.slitem as Product,
  slrecnbr as ReceiptNum,
 
 (select max(IRINV#) from itemrech RH where RH.IRRECNBR = slrecnbr and rh.IRITEM = slitem and IRSRC = ''P'')
 
 as ManningtonInvoice,
 
 SHLINE.SLDESC as DisplayProvided,
 SHLINE.SLBLUS as BillableUnitsShipped, 
 SHLINE.SLECST as LandedCost,
 itemmast.imrcst as NetCost,
 ''50%'' as PercentageOfDistSupport,
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
/* left join itemrech RH on (RH.IRRECNBR = slrecnbr and rh.IRITEM = slitem and IRSRC = ''P'') */

WHERE SHHEAD.SHIDAT between ''10/01/2012'' and ''11/30/2012''

AND shhead.shotyp = ''DP''
and itemmast.imvend in (''10131'', ''10133'') 
and IMCOMMRES <> ''C''

')