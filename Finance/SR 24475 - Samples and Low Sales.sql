/* 

Created By:  Thomas Van Nuys
Date Created: 08/26/2014

SR #24475

Class2 code 992 - employee accounts - excluded

Unused join
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		left join salesman on shline.SLSLMN = salesman.smno


		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
*/


select *
from openquery(gsfl2k,'

select  billto.cmcust as Acct,
billto.cmname as BillToCustomer,
TMDESC as Terms,

sum(sleprc) as Sales

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join arterms on TMTERM = billto.CMTERM
		
where year(shidat) in (2014)
and cmdelt <> ''H''


and billto.cmcust in (select s.shbil# 
						from shhead s 
						join custextn m on s.shbil# = m.CEXCUST
						where s.SHOTYP in (''SA'',''SD'')
						and year(s.shidat) = 2014
						and m.CEXCLASS not in (''992'',''999'')  /* 992 Employee Accounts, 999 Closed */
					 )

group by billto.cmcust,
TMDESC,
billto.cmname

having sum(sleprc) < 25000

')


