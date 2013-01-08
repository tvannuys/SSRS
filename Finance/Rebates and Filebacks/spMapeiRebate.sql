USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spMapeiRebate]    Script Date: 01/08/2013 11:08:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spMapeiRebate] 

@StartDate varchar(10),
@EndDate varchar(10)

as

declare @sql varchar(4000)
declare @Vendor varchar(6)

set @Vendor = '16106'
set @StartDate = '07/01/2012'
set @EndDate = '09/30/2012'


/*

PLRQTY instead of plqrec

*/

set @sql = '

select Company,
Location,
PONum,
POSeqNum,
RevPO,
PODateIssued,
ReceiptDate,
PLRECNBR as ReceiptNum,
VendNbr,
ItemNbr,
PLALTITM as AltId,
ItemDesc,
Imfact,

case  
	when (imum2 IN (''SQYD'',''SYD'') and IMDIV<> 10) then (plrqty*imfact)/9
	else plrqty*imfact
end as AdjustedReceiptQty,

case  
	when (imum2 IN (''SQYD'',''SYD'') and IMDIV<> 10) then 
		((plrqty*imfact)/9)*PLRCST
		else plrqty*imfact*PLRCST
end as AdjustedReceiptValue

from openquery(GSFL2K,''

SELECT POLHIST.PLCO AS Company, 
POLHIST.PLLOC AS Location, 
POLHIST.PLPO# AS PONum, 
POLHIST.PLSEQ# AS POSeqNum, 
POHHIST.PHRETURN AS RevPO, 
POHHIST.PHDOI AS PODateIssued, 
POLHIST.PLVEND AS VendNbr, 
POLHIST.PLITEM AS ItemNbr, 
PLALTITM,
POLHIST.PLDESC AS ItemDesc, 
ITEMMAST.IMPRCD AS ProdCode, 
Itemmast.imum2,
itemmast.imdiv,
plrqty,
imfact,
plrcst,
POLHIST.PLDIRS AS FactoryOrder, 
POLHIST.plrqty AS QtyReceived, 
POLHIST.PLAPQT, 
POLHIST.PLAPFQT, 
ITEMMAST.IMWGHT AS Weight, 
POLHIST.PLFACT AS UnitFactor,  
POLHIST.PLACTN AS POAction,  
POLHIST.PLAFDT AS APFreightInvoiceDate,
 POLHIST.PLAFUS AS APFreightUser,
 POLHIST.PLAMDT AS APMatlInvoiceDate,
 POLHIST.PLAMUS AS APMatlUser,
 POLHIST.PLRDAT AS ReceiptDate,
 PLRECNBR,
 POLHIST.PLAMIV AS APMatlInvoiceNum,
 POLHIST.PLRUSR AS ReceiptUser,
 POLHIST.PLDLM AS DateLastMaint,
 POLHIST.PLTLM AS TimeLastMaint,
 POLHIST.PLULM AS UserLastMaint,
 POLHIST.PLCOST AS POMatlCost,
 POLHIST.PLFFAC AS POFreightFactor,
 POLHIST.PLFFACOR AS FrtFactOverride,
 POLHIST.PLRCST AS ReceiptCost,
 ITEMMAST.IMCOST AS ItemMastLandCost,
 ITEMMAST.IMRCST AS ItemMastMatlCost,
 ITEMXTRA.IMFFAC AS ItemMastFrtUnitCost,
 POLHIST.PLRFFC AS ReceiptFrtFactor,
 POLHIST.PLAPFAM AS APFrtAmt,
 POHHIST.PHALLOCTN,
 POHHIST.PHALLOCPER,
 POHHIST.PHEQUALIZ,
 POHHIST.PHEQUALPER,
 POLHIST.PLFCRG,
 ITEMMAST.IMFMCD,
 POLHIST.PLSERL,
 POLHIST.PLIDKY,
 POLHIST.PLRSRL,
 POLHIST.PLRDYL,
 POLHIST.PLDYLT,
 POLHIST.PLSMDYLT

FROM POLHIST 
LEFT JOIN ITEMMAST ON POLHIST.PLITEM = ITEMMAST.IMITEM
INNER JOIN POHHIST ON (POLHIST.PLCO = POHHIST.PHCO 
						AND POLHIST.PLLOC = POHHIST.PHLOC
						AND POLHIST.PLPO# = POHHIST.PHPO#
						AND POLHIST.PLREL# = POHHIST.PHREL#) 
LEFT JOIN ITEMXTRA ON POLHIST.PLITEM = ITEMXTRA.IMXITM

where POLHIST.PLVEND in (' + @Vendor + ') 
AND POLHIST.PLACTN=''''R'''' 
AND POLHIST.PLRDAT Between ''''' + @StartDate + ''''' And ''''' + @EndDate + '''''
'')
'

--select @sql
exec(@sql)



GO


