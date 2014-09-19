/* 


Created By:  Thomas Van Nuys
Date Created: 9/12/2014

SR #25320

--TODO: 
Put initial query in temp table
How to add current values for Open Orders, 
On PO, 
Inventory Value - added row with current date?

Unused join

		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
*/

-- drop table #CustomerFreightAnalysis

IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#TempCompany2Summary'))
	BEGIN
		DROP TABLE #TempCompany2Summary
	END;
/* 
=====================================================================================	

-- Sales Data

=====================================================================================	
*/

select *,
CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as OrderDate,
0 as OpenOrders,
0 as OnPO,
0 as InventoryValue

into #TempCompany2Summary

from openquery(gsfl2k,'

select  slslmn,
salesman.smname as SalesPerson,
billto.cmcust as Acct,
billto.cmname as BillToCustomer,
soldto.cmname as SoldToCustomer,
shidat,
sldiv,
dvdesc as Division,

slprcd,
pcdesc as ProductCode,

sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as ExtendedCost,
sum(sleprc) as ExtendedPrice


from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		left join salesman on shline.SLSLMN = salesman.smno
		
where year(shidat) in (2014)
and month(shidat) >= month(current_date) - 3

and shco=2

group by slslmn,
salesman.smname,
billto.cmcust,
billto.cmname,
soldto.cmname,
shidat,
sldiv,
dvdesc,

slprcd,
pcdesc

')

/*
=====================================================================================	

Update Open order Value

=====================================================================================	

*/

insert into #TempCompany2Summary (SLSLMN,
SALESPERSON,
ACCT,
BILLTOCUSTOMER,
SOLDTOCUSTOMER,
SHIDAT,
SLDIV,
DIVISION,
SLPRCD,
PRODUCTCODE,
EXTENDEDCOST,
EXTENDEDPRICE,
OrderDate,
OpenOrders,
OnPO,
InventoryValue)

select i2.oLSLMN,
i2.SALESPERSON,
i2.ACCT,
i2.BILLTOCUSTOMER,
i2.SOLDTOCUSTOMER,
i2.OpenOrderDate,
i2.oLDIV,
i2.DIVISION,
i2.oLPRCD,
i2.PRODUCTCODE,
EXTENDEDCOST,
0,
CONVERT(datetime, CONVERT(VARCHAR(10), OpenOrderDate)),
i2.ExtendedPrice as OpenOrders,
0 as OnPO,
0 as InventoryValue

from openquery(gsfl2k,'select  olslmn,
						salesman.smname as SalesPerson,
						billto.cmcust as Acct,
						billto.cmname as BillToCustomer,
						soldto.cmname as SoldToCustomer,
						current_date as OpenOrderDate,
						oldiv,
						dvdesc as Division,

						olprcd,
						pcdesc as ProductCode,

						sum(oLECST+oLESC1+oLESC2+oLESC3+oLESC4+oLESC5) as ExtendedCost,
						sum(oleprc) as ExtendedPrice


						from ooline
								
								left JOIN ooHEAD ON (ooLINE.oLCO = ooHEAD.ohCO 
															AND ooLINE.oLLOC = ooHEAD.oHLOC 
															AND ooLINE.oLORD# = ooHEAD.oHORD# 
															AND ooLINE.oLREL# = ooHEAD.oHREL#) 
								left JOIN CUSTMAST billto ON ooHEAD.oHBIL# = billto.CMCUST 
								left join custmast soldto on oohead.ohcust = soldto.cmcust
								LEFT JOIN ITEMMAST ON ooLINE.olITEM = ITEMMAST.IMITEM 
								LEFT JOIN DIVISION ON ooLINE.olDIV = DIVISION.DVDIV 
								LEFT JOIN PRODCODE ON ooLINE.olPRCD = PRODCODE.PCPRCD 
								left join salesman on ooline.olSLMN = salesman.smno
								
						where ohco=2

						group by olslmn,
						salesman.smname,
						billto.cmcust,
						billto.cmname,
						soldto.cmname,
						current_date,
						oldiv,
						dvdesc,

						olprcd,
						pcdesc') as i2

/*
=====================================================================================	

Next Step - Set PO value

=====================================================================================	

*/
insert into #TempCompany2Summary (
slslmn,
salesperson,

ACCT,
BILLTOCUSTOMER,
SOLDTOCUSTOMER,
EXTENDEDCOST,
EXTENDEDPRICE,

SHIDAT,
SLDIV,
DIVISION,
SLPRCD,
PRODUCTCODE,
OrderDate,
OpenOrders,
OnPO,
InventoryValue)

select 
0,
' ',			-- SalesPerson
' ',			-- Acct
' ',			-- BillToCustomer
' ',			-- SoldToCustomer
0,				-- ExtendedCost
0,				-- ExtendedPrice

GETDATE(),
i3.dvdiv,
i3.dvdesc,
i3.imprcd,
i3.pcdesc,
GETDATE(),
0,
i3.OnPOValue,
0

from openquery(gsfl2k,'select imprcd, dvdiv,
						dvdesc,
						pcdesc,
						sum((PLBLUO-PLBLUR)*plcost) as OnPOValue
						from poline
						join itemmast on plitem = imitem
						left join division on imdiv = dvdiv
						left join prodcode on imprcd = pcprcd
						where plco = 2
						and PLDELT <> ''C''
						group by imprcd,dvdiv,dvdesc,pcdesc
						
						') i3 


/*
=====================================================================================	

Next Step - Set InventoryValue

=====================================================================================	
*/

insert into #TempCompany2Summary (
slslmn,
salesperson,

ACCT,
BILLTOCUSTOMER,
SOLDTOCUSTOMER,
EXTENDEDCOST,
EXTENDEDPRICE,

SHIDAT,
SLDIV,
DIVISION,
SLPRCD,
PRODUCTCODE,
OrderDate,
OpenOrders,
OnPO,
InventoryValue)

select 
0,
' ',			-- SalesPerson
' ',			-- Acct
' ',			-- BillToCustomer
' ',			-- SoldToCustomer
0,				-- ExtendedCost
0,				-- ExtendedPrice

GETDATE(),
i4.dvdiv,
i4.dvdesc,
i4.imprcd,
i4.pcdesc,
GETDATE(),
0,
0,
i4.SalesUOMOnHand*imrcst

FROM OPENQUERY(GSFL2K, 'select imprcd, dvdiv,
						dvdesc,
						pcdesc,
						imrcst,
						
						case 
							when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = '' '') then sum(((IbQOH-ibqoo)*itemmast.IMFACT))
							when (itemmast.IMMD = ''M'' and itemmast.IMMD2 = ''D'') then sum((((IbQOH-ibqoo)*itemmast.IMFACT)/itemmast.IMFAC2))
							else sum(0)
						end as SalesUOMOnHand
						
						FROM itembal
						JOIN itemmast ON ibitem = imitem
						left join division on imdiv = dvdiv
						left join prodcode on imprcd = pcprcd
						
						WHERE ibco = 2
						AND  ibqoh - ibqoo > 0	
						group by imprcd,dvdiv,dvdesc,pcdesc,imrcst,immd,immd2
						
					') i4
					
/*
=====================================================================================	

Final Step - Get Data

=====================================================================================	

*/

select * from #TempCompany2Summary