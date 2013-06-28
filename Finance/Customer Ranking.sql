/*

Will Crites request - 5/16/2013

SR 11895



Calculations:


Vendor Columns

Company 1:

10131 MANNINGTON MILLS INC
 10202 ROPPE RUBBER CORPORATION
 22666 GALA MANUFACTURING
 22674 GREENFIELD FLOORS
 12825 LEGGETT & PLATT
 12384 WF TAYLOR COMPANY INC
 22361 TRAXX CORP
 16106 MAPEI CORPORATION
  2510 LATICRETE
 24020 ENGINEERED FLOORS LLC
  1573 JOHNSONITE
 15659 CUSTOM BUILDING PRODUCTS

Company 2:

24213 ARMSTRONG WORLD IND. COMM
 16037 ARMSTRONG WORLD IND.
  1573 JOHNSONITE
 22666 GALA MANUFACTURING
 22674 GREENFIELD FLOORS
 22312 ARMSTRONG WORLD - WOOD
 16088 AMORIM FLOORING WICANDERS
 16020 MATS INC
 16006 SWIFF TRAIN
 11786 US RUBBER & RECYCLING INC
 22859 BBOSS
 10710 DURABLE MAT COMPANY

*/


select *
from openquery(gsfl2k,'
select  shco as Company,
billto.cmcust as Customer,
billto.cmname as CustName,
smname as SalesPerson,
year(shidat) as Year,

sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as COGS,
sum(sleprc) as Revenue,
sum(sleprc)- sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as GrossMargin

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		left join salesman on billto.CMSLMN = salesman.smno
		
where shco = 1
and billto.cmcust in (''1001786'',''1006826'')
and year(shidat) in (2011,2012,2013)

group by 
shco,
billto.cmcust,
billto.cmname,
smname,
year(shidat)


')


/* # of Sales Lines  */

select * from openquery(gsfl2k,'
select shbil#,
year(shidat) as Year,
count(*) 

from shline
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 

where shco = 1
and shbil# in (''1001786'',''1006826'')
and year(shidat) in (2011,2012,2013)

group by shbil#,
year(shidat)
')

/* 

Avg order size  

Average Order size
	Sales dollars divided by the count of sales orders placed by the customer.  Releases, which break up orders based on our fulfillment rules will be ignored.  
	Should any order types be ignored (samples, claims, etc)?

*/


/* Count of orders - excluding releases */

select * from openquery(gsfl2k,'
select shbil#,
year(shidat), 
count(distinct(shco + shloc + shord#))

from shhead

where shco = 1
and shotyp not in (''CL'', ''SA'', ''DP'')
and shbil# in (''1001786'',''1006826'')
and year(shidat) in (2011,2012,2013)

group by shbil#,
year(shidat)
')

/*
Returns %
	Sales $ on RA orders / Total Sales Dollars not on RA orders

*/

select *
from openquery(gsfl2k,'
select  shco as Company,
billto.cmcust as Customer,
billto.cmname as CustName,
year(shidat) as Year,

sum(sleprc) as Revenue

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		
where shco = 1
and shotyp = ''RA''
and billto.cmcust in (''1001786'',''1006826'')
and year(shidat) in (2011,2012,2013)

group by 
shco,
billto.cmcust,
billto.cmname,
year(shidat)

')

/* Sales for Key Vendors */

/*        Mannington  */

select * from openquery(gsfl2k,'
select h.shco,
billto.cmcust,
billto.cmname,
year(shidat) as Year,
sum(sleprc) 

from shline L
JOIN SHHEAD H ON (L.SLCO = H.SHCO AND L.SLLOC = H.SHLOC AND L.SLORD# = H.SHORD# AND L.SLREL# = H.SHREL# AND L.SLINV# = H.SHINV#) 
left JOIN CUSTMAST billto ON H.SHBIL# = billto.CMCUST 

where L.slvend = 10131 
and billto.cmcust in (''1001786'',''1006826'')
and year(shidat) in (2011,2012,2013)

group by h.shco,
billto.cmcust,
billto.cmname,
year(shidat) 

')

/*        10202 ROPPE RUBBER CORPORATION  */

select * from openquery(gsfl2k,'
select h.shco,
billto.cmcust,
billto.cmname,
year(shidat) as Year,
sum(sleprc) 

from shline L
JOIN SHHEAD H ON (L.SLCO = H.SHCO AND L.SLLOC = H.SHLOC AND L.SLORD# = H.SHORD# AND L.SLREL# = H.SHREL# AND L.SLINV# = H.SHINV#) 
left JOIN CUSTMAST billto ON H.SHBIL# = billto.CMCUST 

where L.slvend = 10202 
and billto.cmcust in (''1001786'',''1006826'')
and year(shidat) in (2011,2012,2013)

group by h.shco,
billto.cmcust,
billto.cmname,
year(shidat) 

')