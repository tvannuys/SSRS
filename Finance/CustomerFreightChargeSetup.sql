

/*  Will Crites

	SR 12717     
	
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

cexclass,
ccldesc as CustomerClassDesc,

c1.CMVIA as MasterShipVia,
shipvia.videsc as ShipViaDesc,
c1.CMDRT1 as Route1,
c1.CMDRT2 as Route2,

route.rtamt,
route.rttype,

CCVIAC as MiscChargeShipViaCode,
sv2.videsc as MiscChargeShipViaDesc,


CCSTY1 as DelChargeType,
CCSAM1 as DeliveryCharge,

CCSTY4 as MiscFreightType,
CCSAM4 as MiscFreight,

rlpric as Recurring

from custmast c1
left join custextn on cexcust = c1.cmcust
/* left join custclas on (cexclass = clscod and CLSLOC = 50 and clsco = 1) */
left join route on rtrout = c1.cmdrt1
left join CUSTMSCG on CCCUST = c1.cmcust  /* header misc charge override by customer */
left join RBLINE on (RLCUST = c1.cmcust and rlitem = ''FREIGHT'')
left join SHIPVIA on shipvia.vicode = c1.cmvia
left join SHIPVIA sv2 on sv2.vicode = CCVIAC
left join CUSTMAST Parent on Parent.CMCUST = custextn.cexcust
left join CUCLMAST on cexclass = cclclass

where cexclass not in (''201'',''202'')
and c1.cmdelt <> ''H'' /* closed account */

order by parent.cmname
')