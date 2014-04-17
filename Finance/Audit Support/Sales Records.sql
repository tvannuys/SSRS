select * from openquery (gsfl2k,'

select	slinv# as InvoiceNum,
		sldate as InvoiceDate,
		shodat as OrderDate,
		shotyp as OrderType,
		slco as Co,
		slloc as Loc,
		slcust as CustNum,
		cmname as CustName,
		right(cmadr3,2) as State,
		slitem as ItemNum,
		sldesc as ItemDesc,
		slprcd as ProdCode,
		slfmcd as FamilyCode,
		slvend as VendNum,
		slqshp as ShipQtyInvUnit,
		slblus as ShipQtyBillUnit,
		slpor as PriceOverride,
		slpric as UnitPrice,
		slscs4 as UnitFileback,
		slscs5 as UnitBuyingGroup,
		sleprc as ExtendedPrice,
		slecst as ExtendedCost,
		slesc4 as ExtendedFileback,
		slesc5 as ExtendedBuyingGroup,
		slgl# as SalesGL,
		slinvgl as InventoryGL,
		slcogsgl as COGSGL,
		shuser
		
from shline sl
	left join shhead sh on (sh.shco=sl.slco and sh.shloc=sl.slloc and sh.shord#=sl.slord# and sh.shrel#=sl.slrel# and sh.shinv#=sl.slinv# and sh.shidat=sl.sldate)
	left join custmast cm on cm.cmcust = sl.slcust

where slco=2
	and sldate between ''01/01/2011'' and ''12/31/2011''
	and shuser <> ''ARMDATA''
	
	
order by sldate asc
	
')