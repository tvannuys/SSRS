/* For Mary Harchuck - SR 8094

If run multiple times drop the #ArmstrongItems before running a second time

*/


select * 
into #ArmstrongItems
from openquery(gsfl2k,'
select imitem as ARMItems,
imdiv,
imfmcd,
imprcd,
pcdesc,
imitem,
imcolr,
imsi as MasterStock,
imdrop

from itemmast
left join prodcode on imprcd = pcprcd
where imvend = 22312
and imiitm = imitem

')


select AI.imitem as Item,
ai.imdiv as DivCode,
ai.imfmcd as FamilyCode,
ai.imprcd as ProdCode,
ai.pcdesc as ProductCodeDesc,
ai.imcolr as Color,
ai.MasterStock as MasterStockFlag,
ai.imdrop as DropFlag,
OQ.*,

h.ihs$01 as JanSales2012,
h.ihs$02 as FebSales2012,
h.ihs$03 as MarSales2012,
h.ihs$04 as AprSales2012,
h.ihs$05 as MaySales2012,
h.ihs$06 as JunSales2012,
h.ihs$07 as JulySales2012,
h.ihs$08 as AugSales2012,
h.ihs$09 as SeptSales2012,
h.ihs$10 as OctSales2012,


h.ihsq01 as JanQty2012,
h.ihsq02 as FebQty2012,
h.ihsq03 as MarQty2012,
h.ihsq04 as AprQty2012,
h.ihsq05 as MayQty2012,
h.ihsq06 as JuneQty2012,
h.ihsq07 as JulyQty2012,
h.ihsq08 as AugQty2012,
h.ihsq09 as SeptQty2012,
h.ihsq10 as OctQty2012

from #ArmstrongItems AI
left join 

openquery(gsfl2k,'
select 
(select sum(sleprc) from shline where slitem = imitem and sldate > current_date - 12 months) as Last12MonthsSales$,
(select sum(SLBLUS) from shline where slitem = imitem and sldate > current_date - 12 months) as Last12MonthsSalesQty,
(select sum(ibqoh) from itembal where ibitem = imitem) as OnHand,
(select sum(ibqoo) from itembal where ibitem = imitem) as Committed,
(select sum(ibqbo) from itembal where ibitem = imitem) as BackOrderQty,
(select sum(ibqoov) from itembal where ibitem = imitem) as OnPO,
(select sum(isvalu) from itemstat where isitem = imitem and isloc=98) as InvValue,

ihs$01 as JanSales2011,
ihs$02 as FebSales2011,
ihs$03 as MarchSales2011,
ihs$04 as AprilSales2011,
ihs$05 as MaySales2011,
ihs$06 as JuneSales2011,
ihs$07 as JulySales2011,
ihs$08 as AugSales2011,
ihs$09 as SeptSales2011,
ihs$10 as OctSales2011,
ihs$11 as NovSales2011,
ihs$12 as DecSales2011,

ihsq01 as JanQty2011,
ihsq02 as FebQty2011,
ihsq03 as MarQty2011,
ihsq04 as AprQty2011,
ihsq05 as MayQty2011,
ihsq06 as JuneQty2011,
ihsq07 as JulyQty2011,
ihsq08 as AugQty2011,
ihsq09 as SeptQty2011,
ihsq10 as OctQty2011,
ihsq11 as NovQty2011,
ihsq12 as "Dec Qty 2011",

imitem

from itemmast
left join itemhist on (imitem = ihitem and ihyear = 2011)

where imvend = 22312

/* and ihitem in (''ARL0207'',''ARL0208'',''ARL6568'') */
') OQ on OQ.imitem = AI.ARMITEMS

left join gsfl2k.B107FD6E.gsfl2k.itemhist H on (h.ihitem=AI.ARMITEMS and h.ihyear = 2012)