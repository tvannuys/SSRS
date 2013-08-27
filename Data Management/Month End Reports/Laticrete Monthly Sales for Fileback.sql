select * from openquery (gsfl2k,'

select	slinv# as InvoiceNum,
		sldate as InvoiceDate,
		slcust as CustNum,
		cmname as CustName,
		left(cmadr3,23) as City,
		right(cmadr3,2) as State,
		slitem as ItemNum,
		sldesc as ItemDesc,
		slqshp as ShipQty,
		slpric as UnitPrice,
		sleprc as ExtendedPrice,
		slscs4 as UnitFileback,
		slesc4 as ExtendedFileback
				

from shline sl
	left join shhead sh on (sh.shco=sl.slco and sh.shloc=sl.slloc and sh.shord#=sl.slord# and sh.shrel#=sl.slrel# and sh.shinv#=sl.slinv# and sh.shidat=sl.sldate)
	left join custmast cm on cm.cmcust = sl.slcust
	
where (year(sldate)=year(current_date - 1 month) and month(sldate)=month(current_date)-1)
	and slscs4 <> 0
	and slco = 1
	and slvend = 2510
	
')