/* SR 16963 

Account List, contacts with email addresses



*/

select * from openquery(gsfl2k,'
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
CUSTXTRA.CXE_MAIL AS Main_EMail, 
cncfname as ContactFirstName,
cnclname as ContactLastName,
cnce_Mail as ContactEmail

from custmast c
left join CONTXREF cm on c.cmcust = cm.ccnxacct
left join contcont ct on ct.cnccontid = cm.ccnxcontid
left JOIN SALESMAN ON c.CMSLMN = SALESMAN.SMNO 
left JOIN CUSTXTRA ON c.CMCUST = CUSTXTRA.CXCUST 

where c.cmslmn = 433
and cnce_Mail <> '' ''

order by c.cmslmn,
salesman.smname,
c.cmcust,
cncfname
')

