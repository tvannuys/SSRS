USE [GartmanReport]
GO

/****** Object:  View [dbo].[CustomerYTDSales]    Script Date: 06/14/2013 14:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



alter VIEW [dbo].[CustomerYTDSales]
AS


select Company,
SalesName,
BillToCustID,
BillToCustName,
BillToCity,
BillToState,
CONVERT(datetime, CONVERT(VARCHAR(10), sldate)) as InvoiceDate,
VendorNum,
VendorName,
FamilyCode,
FamilyCodeDesc,
Division,
DivisionDesc,
Price,
Cost,
Profit

from openquery(gsfl2k,'
select  billto.cmcust as BillToCustID,
billto.cmname as BillToCustName,
Left(billto.CMADR3,23) as BillToCity,
Right(billto.CMADR3,2) AS BillToState,
shco as Company,
smname as SalesName,
sldate,
SHLINE.SLVEND AS VendorNum,
vmname as VendorName,
SHLINE.SLFMCD AS FamilyCode, 
FAMILY.FMDESC AS FamilyCodeDesc, 
SHLINE.SLDIV AS Division, 
DIVISION.DVDESC AS DivisionDesc, 
sum(SLEPRC) AS Price, 
sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as Cost,
sum(sleprc-(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)) AS Profit

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno
		
where shhead.shco = 1
and (
	year(sldate)=year(current_date) or 
	(year(sldate)=year(current_date)-1 and month(sldate) < month(current_date)) or
 	(year(sldate)=year(current_date)-1 and month(sldate) = month(current_date) and day(sldate) <= day(current_date))  
	)
and sldate >= current_date - 18 months

group by billto.cmcust,
billto.cmname,
Left(billto.CMADR3,23),
Right(billto.CMADR3,2),
shco,
smname,
sldate,
SHLINE.SLVEND,
vmname,
SHLINE.SLFMCD,
FAMILY.FMDESC,
SHLINE.SLDIV,
DIVISION.DVDESC


')




GO


