USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spNoPriceListEmailList]    Script Date: 02/12/2013 16:51:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[spNoPriceListEmailList]

@SalesPersonNumber varchar(5)

as

declare @sql varchar(2000)

set @sql = 'select * from openquery(gsfl2k,''

SELECT CUSTMAST.CMCO AS Company,
CUSTMAST.CMCUST AS CustNbr, 
CUSTMAST.CMNAME AS CustName, 
CUSTMAST.CMSLMN AS SalesmanNbr, 
SALESMAN.SMNAME AS RepName, 
custcndtl.CCDCNT AS ContactName, 
custcndtl.CCDE_MAIL AS "PriceListE-MailAddr"


FROM  CUSTMAST 

LEFT JOIN SALESMAN ON CUSTMAST.CMSLMN = SALESMAN.SMNO
LEFT JOIN custcndtl ON (CUSTMAST.CMCUST = custcndtl.CCDCUS and CCDDOC = ''''@PL'''')
LEFT JOIN CUSTEXTN ON CUSTMAST.CMCUST = CUSTEXTN.CEXCUST
left JOIN CUCLMAST ON CUCLMAST.CCLCLASS = CUSTEXTN.CEXCLASS

WHERE CUSTEXTN.CEXCLASS <> ''''999''''
AND CUSTMAST.CMDELT <> ''''H''''
and custmast.CMSLMN = ''''' + @SalesPersonNumber + ''''' 
and ccde_mail is null


'')

'

--select @sql

exec (@sql)
GO


