/* Customer Freight Analysis

Will Crites

AP Distribution details

Process in AP to add customer to comment field in AP started 6/1/2013

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
	ShipViac char(1) null,
	[Source] char(25) null
	)

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,
' ' as ShipVia,
' ' as ShipViaCode,

 [Source]
from openquery(gsfl2k,'
select APDIDT as TranDate,
APDLAMT*-1 as TranAmt,
APDLCOMT as Customer,
''AP DIST'' as Source

from apdist
join apdetail on (apdlbat = apdebat and apdekey = apdlkey)
where apdlgl in (''610700'',''610500'',''610600'')
and apdidt >= ''6/1/2013''
and (apdlcomt like ''1%'' or apdlcomt like ''4%'' or apdlcomt like ''6%'')

')


/* HEADER Charges 1 */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,ShipVia,ShipViaCode, [Source]
 from openquery(gsfl2k,'
select shidat as TranDate,
shsam1 as TranAmt,
shbil# as Customer,
SHVIA as ShipVia,
shviac as ShipViaCode,

''Header Misc Charge'' as Source

from shhead
where shidat > ''6/1/2013''
/* and shbil# = ''1002104'' */
and shsam1 <> 0
')

/* HEADER Charges 2 */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,ShipVia,ShipViaCode,  [Source]
 from openquery(gsfl2k,'
select shidat as TranDate,
shsam4 as TranAmt,
shbil# as Customer,
shvia as ShipVia,
shviac as ShipViaCode,
''Header Misc Charge 2'' as Source

from shhead
where shidat > ''6/1/2013''
/* and shbil# = ''1002104'' */
and shsam4 <> 0
')



/* LINE misc charges */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer,
' ' as ShipVia,
' ' as ShipViaCode,
[Source]
 from openquery(gsfl2k,'
select shidat as TranDate,
slsam2 as TranAmt,
shbil# as Customer,
''Line Misc Charge'' as Source

from shline
left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
where shidat > ''6/1/2013''
/* and shbil# = ''1002104'' */
and slsam2 <>0
')


/* Freight LINES */

insert into #CustomerFreightAnalysis
select TranDate,TranAmt,Customer, 
' ' as ShipVia,
' ' as ShipViaCode,
[Source]
 from openquery(gsfl2k,'
select shidat as TranDate,
sleprc as TranAmt,
shbil# as Customer,
''Freight Invoice Lines'' as Source

from shline
left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
where shidat > ''6/1/2013''
/* and shbil# = ''1002104''  */
and slprcd in (640,742,743)
and sleprc <> 0
')

/* Expand on Customer Attributes */

select A.Customer, OQ.cmname as CustName, A.TranDate, A.TranAmt, A.[Source], A.ShipVia, A.ShipViac
from #CustomerFreightAnalysis A
left join openquery(gsfl2k,' select cmcust,cmname from custmast ') OQ on OQ.cmcust = A.Customer


