/* SR 7713

CCA weekly sales reporting for the wood program

*/


select * from openquery(gsfl2k,'
select distinct Right(linecust.CMADR3,2) as State,
linecust.cmcust,
linecust.cmname,

imitem,
IMSKEY as ManfSKU,
imdesc, 

(select IMUM2 
	from itemmast i
	where i.imitem = shline.slitem)
	as UOM,

(select sum(slblus) 
	from shline l 
	where l.slitem = shline.slitem 
	and l.slcust = shline.slcust
	and l.sldate between (current_date - 10 days) and (current_date - 4 days))
	as WeeklyQtySold,

(select sum(sleprc) 
	from shline l 
	where l.slitem = shline.slitem 
	and l.slcust = shline.slcust
	and l.sldate between (current_date - 10 days) and (current_date - 4 days))
	as WeeklyDollars,


(select sum(slblus) 
	from shline l 
	where l.slitem = shline.slitem 
	and l.slcust = shline.slcust
	and year(l.sldate) = year(current_date)
	and month(l.sldate) = month(current_date)
	and l.sldate <= current_date - 4 days)
	as MTDQtySold,

(select sum(sleprc) 
	from shline l 
	where l.slitem = shline.slitem 
	and l.slcust = shline.slcust
	and year(l.sldate) = year(current_date)
	and month(l.sldate) = month(current_date)
	and l.sldate <= current_date - 4 days)
	as MTDDollars,

(select sum(slblus) 
	from shline l 
	where l.slitem = shline.slitem 
	and l.slcust = shline.slcust
	and year(l.sldate) = year(current_date)
	and l.sldate <= current_date - 4 days)
	as YTDQtySold,

(select sum(sleprc) 
	from shline l 
	where l.slitem = shline.slitem 
	and l.slcust = shline.slcust
	and year(l.sldate) = year(current_date)
	and l.sldate <= current_date - 4 days)
	as YTDDollars

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
/* 		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST       */
/*		left join custmast soldto on shhead.shcust = soldto.cmcust       */
		left join custmast linecust on shline.slcust = linecust.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
/*		left join vendmast on slvend = vmvend                            */
/*		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shhead.SHSLSM = salesman.smno              */

where imdiv = 4

and imcls# in (2001,2002,2003,4177,4022,4026)

and year(shidat) = year(current_date)
and shidat <= current_date - 4 days
and slcust in (select cmkcus from custmktg 
				where cmkmkc in (''C1'',''FA'',''PS''))
				
order by Right(linecust.CMADR3,2),
	linecust.cmname,
	imitem


')

/*  All CCA Private Label

imcls# in (2001,2001,2003,4177,4022,4026)

*/




