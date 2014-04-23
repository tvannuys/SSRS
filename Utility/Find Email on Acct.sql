/*  

Used in UTILITY \ Find Gartman Email.rdl

spFindAccountEmail 'aqui'

*/

alter proc spFindAccountEmail

@AddrPortion varchar(30)

as

declare @sql varchar(max)

set @sql = 'select * from openquery(gsfl2k,''

select c.cmslmn as SalesPersonID,
salesman.smname as SalesPerson,
c.cmcust as AcctNum,
c.cmname as Customer,

c.CMADR1 AS Addr1, 
c.CMADR2 AS Addr2, 
substring(c.CMADR3,0,24) AS City, 
substring(c.CMADR3,24,2) AS State, 
c.CMZIP AS ZipCode, 
c.CMPHON AS Phone, 
c.CMATTN AS MainContact, 
CUSTXTRA.CXE_MAIL AS Main_EMail

from custmast c
left JOIN SALESMAN ON c.CMSLMN = SALESMAN.SMNO 
left JOIN CUSTXTRA ON c.CMCUST = CUSTXTRA.CXCUST 

where upper(CUSTXTRA.CXE_MAIL) like ''''%' + upper(@AddrPortion) + '%''''  

'')'

exec(@sql)


