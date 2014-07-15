/* Customer Freight Analysis

Will Crites

AP Distribution details

Process in AP to add customer to comment field in AP started 6/1/2013

SR 23051

sales - SHTOTL
COGS - SHCOST

Left(CMADR3,23) AS City, 
/* FIELD 8 */
CMZIP AS ZipCode, 
/* FIELD 9 */
Right(CMADR3,2) AS State,
*/

-- drop table #CustomerFreightAnalysis

IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#CustomerFreightAnalysis'))
	BEGIN
		DROP TABLE #CustomerFreightAnalysis
	END;

/* AP Details */


create table #CustomerFreightAnalysis (
	TranDate datetime null,
	TranAmt money null,
	Customer char(10) null,
	ShipVia char(15) null,
	ShipViaCode char(1) null,
	Invoice char(6) null,
	InvoiceCount int,
	OrderRoute char(5) null,
	OrderType char(2) null,
	DeliveryCity char(23) null,
	DeliveryState char(2) null,
	[Source] char(25) null
	)

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,
' ' as ShipVia,
' ' as ShipViaCode,
' ' as Invoice,
0 as InvoiceCount,
' ' as OrderRoute,
' ' as OrderType,
' ' as DeliveryCity,
' ' as DeliveryState,

 [Source]
from openquery(gsfl2k,'
select APDIDT as TranDate,
APDLAMT*-1 as TranAmt,
APDLCOMT as Customer,
''AP DIST'' as Source

from apdist
join apdetail on (apdlbat = apdebat and apdekey = apdlkey)
where apdlgl in (''610700'',''610500'',''610600'')
and apdidt >= ''1/1/2014''
and (apdlcomt like ''1%'' or apdlcomt like ''4%'' or apdlcomt like ''6%'')

')


/* HEADER Charges 1 - Delivery Charge */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,ShipVia,ShipViaCode, 
Invoice,
0 as InvoiceCount,
OrderRoute,
OrderType,
DeliveryCity,
DeliveryState,

[Source]

 from openquery(gsfl2k,'
select shidat as TranDate,
shsam1 as TranAmt,
shbil# as Customer,
SHVIA as ShipVia,
shviac as ShipViaCode,
shinv# as Invoice,
shrout as OrderRoute,
sHOTYP as OrderType,
left(sHSTA3,23) as DeliveryCity,
right(sHSTA3,2) as DeliveryState,

''Header Delivery Charge'' as Source

from shhead
where shidat > ''1/1/2014''
/* and shbil# = ''1002104'' */
and shsam1 <> 0
')

/* HEADER Charges 2 - Freight / Handling */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,ShipVia,ShipViaCode,  
Invoice,
0 as InvoiceCount,
OrderRoute,
OrderType,
DeliveryCity,
DeliveryState,

[Source]

 from openquery(gsfl2k,'
select shidat as TranDate,
shsam4 as TranAmt,
shbil# as Customer,
shvia as ShipVia,
shviac as ShipViaCode,
shinv# as invoice,
shrout as OrderRoute,

sHOTYP as OrderType,
left(sHSTA3,23) as DeliveryCity,
right(sHSTA3,2) as DeliveryState,

''Header Freight Charge'' as Source

from shhead
where shidat > ''1/1/2014''
/* and shbil# = ''1002104'' */
and shsam4 <> 0
')



/* LINE misc charges */

insert into #CustomerFreightAnalysis

select TranDate,TranAmt,Customer,
ShipVia,
ShipViaCode,

--' ' as ShipVia,
--' ' as ShipViaCode,
Invoice,
0 as InvoiceCount,
OrderRoute,
OrderType,
DeliveryCity,
DeliveryState,

[Source]

 from openquery(gsfl2k,'
select shidat as TranDate,
slsam2 as TranAmt,
shbil# as Customer,
shinv# as invoice,
shrout as OrderRoute,
SHVIA as ShipVia,
shviac as ShipViaCode,

sHOTYP as OrderType,
left(sHSTA3,23) as DeliveryCity,
right(sHSTA3,2) as DeliveryState,

''Line Misc Charge'' as Source

from shline
left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
where shidat > ''1/1/2014''
/* and shbil# = ''1002104'' */
and slsam2 <>0
')


/* Freight LINES */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer, 
ShipVia,
ShipViaCode,

--' ' as ShipVia,
--' ' as ShipViaCode,
Invoice,
0 as InvoiceCount,
OrderRoute,

OrderType,
DeliveryCity,
DeliveryState,

[Source]
 from openquery(gsfl2k,'
select shidat as TranDate,
sleprc as TranAmt,
shbil# as Customer,
shvia as ShipVia,
shviac as ShipViaCode,
shinv# as invoice,
shrout as OrderRoute,

sHOTYP as OrderType,
left(sHSTA3,23) as DeliveryCity,
right(sHSTA3,2) as DeliveryState,

''Freight Invoice Lines'' as Source

from shline
left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
where shidat > ''1/1/2014''
/* and shbil# = ''1002104''  */
and slprcd in (640,742,743)
and sleprc <> 0
')

/* Expand on Customer Attributes - put in Temp table proper order */

IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#CustomerFreightAnalysis2'))
	BEGIN
		DROP TABLE #CustomerFreightAnalysis2
	END;


select A.Customer, OQ.cmname as CustName, A.TranDate, A.TranAmt, A.[Source], 
A.ShipVia, A.ShipViaCode, A.Invoice, A.InvoiceCount,A.OrderRoute,
A.OrderType, A.DeliveryCity, A.DeliveryState

into #CustomerFreightAnalysis2

from #CustomerFreightAnalysis A
left join openquery(gsfl2k,' select cmcust,cmname 
							from custmast ') OQ 
			on OQ.cmcust = A.Customer
order by A.Invoice, A.TranAmt

--====================================================================================
--
--  CURSOR TO MARK DUPLICATE INVOICES - PREVENT OVERSTATED SALES JOIN IN FINAL QUERY
--
--====================================================================================

declare @TempInvoice char(6), 
	@PreviousInvoice char(6),
	@TempInvoiceCount int

declare Freight_cursor cursor
	for select invoice, invoicecount
		from #CustomerFreightAnalysis2
		where invoice <> ' ' 
--		order by invoice
	for update of invoicecount;

open Freight_cursor

fetch Freight_cursor
	into @TempInvoice, @TempInvoiceCount

while @@FETCH_STATUS = 0
begin

	if @TempInvoice <> @PreviousInvoice
	begin
		update #CustomerFreightAnalysis2 
		set invoicecount = 1
		where current of Freight_cursor
	end

	set @PreviousInvoice = @TempInvoice

	fetch Freight_cursor
		into @TempInvoice, @TempInvoiceCount
end

close Freight_cursor
deallocate Freight_cursor

--====================================================================================
--
--  FINAL QUERY - join to get sales
--
--====================================================================================

-- SHEMDS = Material Sales only in header


select A.*, B.SHEMDS as MaterialSales, B.shcost as Cost
from #CustomerFreightAnalysis2 A
left join openquery(gsfl2k,'select shinv#,SHEMDS,shcost 
							from shhead 
							where shidat > ''1/1/2014''
							') B on (B.shinv# = A.Invoice and A.InvoiceCount = 1)
where A.InvoiceCount = 0


