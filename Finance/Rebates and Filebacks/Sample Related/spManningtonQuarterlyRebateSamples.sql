USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spManningtonQuarterlyRebateSamples]    Script Date: 04/03/2014 07:18:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Samples 

Now in SSRS - http://sql01/Reports/Pages/Folder.aspx?ItemPath=%2fFinance%2fRebates+and+File+Backs%2fSample+Related&ViewMode=List



*/

CREATE proc [dbo].[spManningtonQuarterlyRebateSamples]

@StartDate varchar(10) = '10/01/2012',
@EndDate varchar(10) = '11/31/2012'

as

declare @sql varchar(3000)

set @sql = '

select * from openquery(gsfl2k,''

SELECT 
 SHIDAT as Date,
 SHOTYP,
 VNCVCUST AS MMIRTLNum,
 BillTo.CMNAME AS RetailerName,
 shline.slinv# as InvoiceNumber,
 shline.slitem as Product,
 SHLINE.SLDESC as SampleProvided,
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
INNER JOIN CUSTMAST BillTo ON SHHEAD.SHBIL# = BillTo.CMCUST
left join vendcust on (billto.cmcust=VNCCUST and vncvend = ''''10131'''')

WHERE SHHEAD.SHIDAT between ''''' + @StartDate + ''''' and ''''' + @EndDate + '''''

AND (ITEMMAST.IMFCRG = ''''S'''' or shotyp = ''''SD'''') 
and shhead.shotyp <> ''''DP''''
and itemmast.imvend in (''''10131'''', ''''10133'''')
and IMCOMMRES <> ''''C''''


'')
'

exec (@sql)

GO

