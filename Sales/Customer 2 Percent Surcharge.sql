/*  2% surcharge - customer exemptions

SR 19577


CCCUST = Acct
CCSTY5 - If * and zero in CCSAM5 then customer is exempt
		If % and zero in CCSAM5 then customer has same as defined amount for the location
		
		
		
		
		CEXPARENT as ParentAcct,
		left join custextn on shhead.shcust = CEXCUST
		
*/

select distinct BillToAcct,
BillToCustomer,
Acct,
SalesPerson,
YTDSales,
LYSales


--ccsam5 as SurchargeAmt,
--CCSTY5 as SurchargeType

from openquery(gsfl2k,'
select CCCUST as Acct,
b.cmcust as BillToAcct,
b.cmname as BillToCustomer,
smname as SalesPerson,

ifnull(
		(
		select sum(sleprc) 
		from shline 
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		where shcust = cccust 
		and year(shidat) = year(current_date)
		)
		,0) as YTDSales,

ifnull(
		(
		select sum(sleprc) 
		from shline 
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		where shcust = cccust 
		and year(shidat) = year(current_date) - 1
		)
		,0) as LYSales,


m.* 

from custmscg m
	left join custmast c on (m.cccust = c.cmcust and ccotyp = '' '')
	left join custmast b on c.cmbill = b.cmcust
	left join salesman on b.CMSLMN = salesman.smno

where ccotyp = '' '' 
and substring(CCCUST,1,1) in (''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'',''0'')
')

where CCSTY5 = '*'
and CCSAM5 = 0
--and BillToAcct in ('1001402', '1006275')
order by BillToAcct,Acct
