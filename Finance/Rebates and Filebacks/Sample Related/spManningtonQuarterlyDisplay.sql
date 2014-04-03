/* 

spManningtonQuarterlyDisplay '01/01/2014', '01/31/2014'

*/

alter proc spManningtonQuarterlyDisplay

@StartDate varchar(10),
@EndDate varchar(10)

as

declare @sql varchar(max)

set @sql = 'select * from openquery(gsfl2k,''
SELECT SHIDAT as Date,  
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
left JOIN CUSTMAST BillTo ON SHHEAD.SHBIL# = BillTo.CMCUST  
left join vendcust on (billto.cmcust=VNCCUST and vncvend = ''''10131'''') 

WHERE SHHEAD.SHIDAT between ''''' + @StartDate + ''''' and ''''' + @EndDate + ''''' 
AND shhead.shotyp = ''''DP''''  
and itemmast.imvend in (''''10131'''', ''''10133'''')   
and IMCOMMRES <> ''''C'''' 

'')' 

exec(@sql)