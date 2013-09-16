

/*  Will Crites

	SR 6069     
	
	* means zero out standard charge from route
	$ means override the route charge -- unless value is zero, then use the route charge
	
	SLESP2 - CUSTLICG


/* NSF */

select * from openquery(gsfl2k,'
select *
from custchck
where bccust=''1006826''
')


/* Summary AR Information */

select * from openquery(gsfl2k,'
select ccrcus as Acct,
ccramtpdue as Late

from custrevw
where ccrcus = ''1006826''
')


select * from openquery(gsfl2k,'
select cmcur,
CMU30+CMO30+CMO60+CMO90 as Past
from custmast
where cmcust=''1006826''
')

*/

select * from openquery(gsfl2k,'
select 
c1.cmco as Company,
Parent.cmcust as ParentAcct,
Parent.cmname as ParentCust,
c1.cmcust, 
c1.cmname, 

substring(c1.CMADR3,24,2) as state,

/*
cexclass,
ccldesc as CustomerClassDesc,
*/


c1.cmcur as CurrentAR,
c1.CMU30+c1.CMO30+c1.CMO60+c1.CMO90 as PastDueAR,
bc#bc as NSFCount,

custstat.csys$ as YTDSales,

/*
(select sum(sleprc) from shline
					left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
					AND SHLINE.SLLOC = SHHEAD.SHLOC 
					AND SHLINE.SLORD# = SHHEAD.SHORD# 
					AND SHLINE.SLREL# = SHHEAD.SHREL# 
					AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		where SHHEAD.SHBIL# = c1.cmcust
		and year(shidat) = year(current_date))
		
		as YTDSales,
*/

/*		
(select sum(sleprc) from shline l2
					left JOIN SHHEAD h2 ON (l2.SLCO = h2.SHCO 
					AND l2.SLLOC = h2.SHLOC 
					AND l2.SLORD# = h2.SHORD# 
					AND l2.SLREL# = h2.SHREL# 
					AND l2.SLINV# = h2.SHINV#) 
		where h2.SHBIL# = c1.cmcust
		and year(shidat) = year(current_date)-1)
		
		as LYYTDSales,
*/

shipvia.videsc as MasterShipVia,
c1.CMDRT1 as Route1,

case
	when route.rtamt is null then 0
	else route.rtamt
end as RouteAmt,

case
	when route.rttype is null then '' ''
	else route.rttype
end as RouteChargeFactor,

rlpric as Recurring

from custmast c1
left join custextn on cexcust = c1.cmcust
left join custstat on (c1.cmcust = custstat.cscust and custstat.csloc = 98 and custstat.csco = c1.cmco)
left join route on rtrout = c1.cmdrt1

left join RBLINE on (RLCUST = c1.cmcust and rlitem = ''FREIGHT'')
left join SHIPVIA on shipvia.vicode = c1.cmvia

left join CUSTMAST Parent on Parent.CMCUST = custextn.cexcust
left join CUCLMAST on cexclass = cclclass

left join custchck on bccust = c1.cmcust

where cexclass not in (''201'',''202'')
and c1.cmdelt <> ''H'' /* closed account */
and (c1.cmcust like ''1%'' or c1.cmcust like ''4%'' or c1.cmcust like ''6%'')

and c1.cmcust in (select cccust from custmscg)

order by parent.cmname
')