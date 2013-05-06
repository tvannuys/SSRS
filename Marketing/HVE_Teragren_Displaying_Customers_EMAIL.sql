/*********************************************************************************
**																				**
** SR# 8517																		**
** Programmer: James Tuttle	Date:05/06/2013										**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - HVE_Teragren Displaying Customers_EMAIL			**
**																				**
**	I need to be able to choose one of our billing codes and a sales rep #		**
**  and have the report show me all the customers that have that billing code   **
**  in their file - their store name, address, customer number.					**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC HVE_Teragren_Displaying_Customers_EMAIL 
	@billCode varchar(2)
	,@salesPerson varchar(3)
AS
BEGIN
DECLARE @sql varchar(4000) = '
 SELECT cbcust								AS CustNbr
		,cmname								AS Name
		,cbblcd								AS BillCode
		,cmslmn								AS Sales
		,cmadr1								AS Address1
		,cmadr2								AS Address2
		,RTRIM(REVERSE(SUBSTRING(REVERSE
			(cmadr3),3,LEN(cmadr3))))		AS City				-- Split city and state up
		,REVERSE(LEFT(REVERSE(cmadr3),2))	AS [State]			-- since it is one field in the DB2
		,ccne_mail							AS EmailAddress
		,ccnplemail							AS PriceListEmail
 FROM OPENQUERY(GSFL2K,	
	''SELECT cbcust
		,cmname
		,cbblcd
		,cmslmn
		,cmadr1
		,cmadr2
		,cmadr3
		,ccne_mail
		,ccnplemail
		
	FROM custbill cb
	LEFT JOIN custmast cm ON cb.cbcust = cm.cmcust
	LEFT JOIN blcdmast blc ON blc.bcblcd = cb.cbblcd
	LEFT JOIN custcont cc ON cc.ccncus = cm.cmcust
	
	WHERE cb.cbblcd = ' + '''' + '''' + @billCode + '''' + '''' + '
		AND cm.cmslmn = ' + '''' + '''' + @salesPerson + '''' + '''' + '
		AND cc.ccne_mail != '''' ''''
	'')'
END
EXEC(@sql)

-- HVE_Teragren_Displaying_Customers_EMAIL T1, 20

/*---------------------------------------------------------------------------------------------------------------------
SELECT GSFL2K_CUSTBILL.CBCUST, 
		GSFL2K_CUSTMAST.CMNAME AS Customer, 
		GSFL2K_CUSTBILL.CBBLCD, 
		GSFL2K_CUSTMAST.CMSLMN, 
		GSFL2K_CUSTMAST.CMADR3, 
		GSFL2K_CUSTCONT.CCNE_MAIL, 
		GSFL2K_CUSTCONT.CCNPLEMAIL
		
FROM ((GSFL2K_CUSTBILL INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_CUSTBILL.CBCUST = GSFL2K_CUSTMAST.CMCUST) 
INNER JOIN GSFL2K_BLCDMAST ON GSFL2K_CUSTBILL.CBBLCD = GSFL2K_BLCDMAST.BCBLCD) 
INNER JOIN GSFL2K_CUSTCONT ON GSFL2K_CUSTMAST.CMCUST = GSFL2K_CUSTCONT.CCNCUS

WHERE (((GSFL2K_CUSTBILL.CBBLCD)="T1" Or (GSFL2K_CUSTBILL.CBBLCD)="T3" Or (GSFL2K_CUSTBILL.CBBLCD)="T4" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="T5") 
	AND ((GSFL2K_CUSTMAST.CMSLMN)=20));
---------------------------------------------------------------------------------------------------------------------*/