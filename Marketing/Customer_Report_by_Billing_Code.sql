/*********************************************************************************
**																				**
** SR# 9385																		**
** Programmer: James Tuttle		Date: 04/16/203									**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - HVE_Commercial_Expressions_Disp_Cust				**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/
--
-- SR# 9937 James Tuttle 04/16/2013 Add a PARM for Bill Codes (multiple)
--
----------------------------------------------------------------------------------
--
-- SR# 11078 James Tuttle 05/22/2013 Add Eamil if flagged for Price List
--
----------------------------------------------------------------------------------

ALTER PROC Customer_Report_by_Billing_Code 
	 @CSV varchar(100)
 
AS

--DECLARE @sql varchar(MAX) 
--SET @sql = '
--BEGIN
 SELECT cbcust									AS CustNbr 
		,cmname									AS CustName
		,cbblcd									AS Bill_Code
		,bcdesc									AS [Description]
		,cmslmn									AS SalesNbr
		,smname									AS SalesName
		,cmadr1									AS Address1
		,cmadr2									AS Address2		
		,RTRIM(REVERSE(SUBSTRING(REVERSE						-- Split up the City and State since
			(CMADR3),3,LEN(CMADR3))))			AS City			-- the data is stored as one record 
		,REVERSE(LEFT(REVERSE(cmadr3),2))		AS [State]	
		,cmzip									AS Zip
		,ccnplemail								AS Email_Yes
		,ccne_mail								AS Email
		
 FROM OPENQUERY(GSFL2K,	
	'SELECT cbcust
		,cmname
		,cbblcd
		,bcdesc
		,cmslmn
		,smname
		,cmadr1
		,cmadr2
		,cmadr3
		,cmzip
		,ccnplemail
		,ccne_mail
		
	FROM custmast cm 
	LEFT JOIN custbill cb ON cb.cbcust = cm.cmcust
	LEFT JOIN blcdmast bcm ON bcm.bcblcd = cb.cbblcd
	LEFT JOIN salesman sm ON sm.smno = cm.cmslmn
	LEFT JOIN custcont cc ON cm.cmcust = cc.ccncus
	
	WHERE cc.ccnplemail = ''Y''
	')
WHERE cbblcd IN (SELECT * FROM dbo.udfCSVToLIst(@CSV))
--END

--EXEC(@sql)
GO

-- Customer_Report_by_Billing_Code 'AL,JT,L8'



/*-------------------------------------------------------------------------------------------------------
-- 
MS Acces 
--
SELECT GSFL2K_CUSTBILL.CBCUST, 
	GSFL2K_CUSTMAST.CMNAME AS Customer, 
	GSFL2K_CUSTBILL.CBBLCD, 
	GSFL2K_CUSTMAST.CMSLMN, 
	GSFL2K_CUSTMAST.CMADR1, 
	GSFL2K_CUSTMAST.CMADR2, 
	GSFL2K_CUSTMAST.CMADR3, 
	GSFL2K_CUSTMAST.CMZIP
	
FROM (GSFL2K_CUSTBILL INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_CUSTBILL.CBCUST = GSFL2K_CUSTMAST.CMCUST) 
INNER JOIN GSFL2K_BLCDMAST ON GSFL2K_CUSTBILL.CBBLCD = GSFL2K_BLCDMAST.BCBLCD

WHERE (((GSFL2K_CUSTBILL.CBBLCD)="CE" Or (GSFL2K_CUSTBILL.CBBLCD)="CX"));
-------------------------------------------------------------------------------------------------------*/