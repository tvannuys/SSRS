/* Find contacts in Gartman that have a particular email address

	Like condition search

spFindEmail thomasv
	
*/

alter proc spFindEmail 

@AddrPortion varchar(30)

as

declare @sql varchar(max)

set @sql = 'select * from openquery(gsfl2k,''

SELECT CUSTMAST.CMCO AS Company,
CUSTMAST.CMCUST AS CustNbr, 
CUSTMAST.CMNAME AS CustName, 
CUSTMAST.CMADR1 AS Addr1, 
CUSTMAST.CMADR2 AS Addr2, 
Left(CMADR3,23) AS City, 
Right(CMADR3,2) AS State, 
CUSTMAST.CMZIP AS ZipCode, 
CUSTMAST.CMPHON AS Phone, 
CUSTMAST.CMFAX AS FaxNbr, 
CUSTMAST.CMSLMN AS SalesmanNbr, 
SALESMAN.SMNAME AS RepName, 
CUSTEXTN.CEXCLASS AS CustTypeCode, 
CUCLMAST.CCLDESC AS CustTypeDesc, 
CCDCONTID as ContactID,
custcndtl.CCDCNT AS ContactName, 
custcndtl.CCDE_MAIL AS "PriceListE-MailAddr",
CCDDOC as Document

FROM  CUSTMAST 

LEFT JOIN SALESMAN ON CUSTMAST.CMSLMN = SALESMAN.SMNO
LEFT JOIN CUSTXTRA ON CUSTMAST.CMCUST = CUSTXTRA.CXCUST 
LEFT JOIN CUSTEXTN ON CUSTMAST.CMCUST = CUSTEXTN.CEXCUST
left JOIN CUCLMAST ON CUCLMAST.CCLCLASS = CUSTEXTN.CEXCLASS
LEFT JOIN custcndtl ON (CUSTMAST.CMCUST = custcndtl.CCDCUS)  

WHERE CUSTEXTN.CEXCLASS <> ''''999'''' 
AND CUSTMAST.CMDELT <> ''''H''''

and ccde_mail is not null
and ccde_mail like ''''%' + @AddrPortion + '%'''' '')'

exec(@sql)
