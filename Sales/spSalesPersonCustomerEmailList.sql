
ALTER proc [dbo].[spSalesPersonCustomerEmailList] 

@SalesPerson varchar(30)

as

declare @sql varchar(2000)

set @sql = '
select * from openquery(GSFL2K,''

SELECT CUSTMAST.CMCUST AS CustNbr, 
CUSTMAST.CMNAME AS CustName, 
CUSTMAST.CMLOC AS Location, 
CUSTMAST.CMADR1 AS Addr1, 
CUSTMAST.CMADR2 AS Addr2, 
substring(CMADR3,0,24) AS City, 
substring(CMADR3,24,2) AS State, 
CUSTMAST.CMZIP AS ZipCode, 
CUSTMAST.CMPHON AS Phone, 
CUSTMAST.CMFAX AS FaxNbr, 
CUSTMAST.CMSLMN AS SalesmanNbr, 
SALESMAN.SMNAME AS RepName, 
CUSTMAST.CMATTN AS Contact, 
CUSTXTRA.CXE_MAIL AS EMail, 
CUSTMAST.CMDELT, 

CMCLAS as ClassCode1,
clsdes as ClassCode1Desc,

CUSTEXTN.CEXCLASS AS CustTypeCode, 
CUCLMAST.CCLDESC AS CustTypeDesc, 
CUSTMAST.CMSLM2 AS Rep2, 
S2.SMNAME AS Rep2Name, 
CUSTMAST.CMCRLM, 
videsc,
CUSTMAST.CMCOD, 
CUSTMAST.CMCASH, 
CUSTMAST.CMCBD,
(select sum(sleprc) from shline where custmast.cmcust = shline.slcust and year(sldate) = year(current_date)) as YTDSales,
(select sum(sleprc) from shline where custmast.cmcust = shline.slcust and sldate > current_date - 1 year) as Sales12Months

FROM  CUSTMAST
left JOIN SALESMAN ON CUSTMAST.CMSLMN = SALESMAN.SMNO 
left JOIN CUSTXTRA ON CUSTMAST.CMCUST = CUSTXTRA.CXCUST 
left JOIN CUSTEXTN ON CUSTMAST.CMCUST = CUSTEXTN.CEXCUST 
LEFT JOIN Salesman s2 ON CUSTMAST.CMSLM2 = S2.SMNO 
left JOIN CUCLMAST ON CUCLMAST.CCLCLASS = CUSTEXTN.CEXCLASS
left join shipvia on custmast.cmvia = shipvia.vicode
left join custclas on (cmco = clsco and cmloc = clsloc and cmclas = clscod)



WHERE (CUSTMAST.CMcust like ''''1%'''' or cmcust like ''''40%'''')
AND CUSTMAST.CMDELT<>''''H''''
AND CUSTEXTN.CEXCLASS<>''''999''''
and SALESMAN.SMNAME like ''''%' + @SalesPerson + '%''''  
 '')'
 
 exec (@sql)
GO


-- exec spSalesPersonCustomerEmailList 40