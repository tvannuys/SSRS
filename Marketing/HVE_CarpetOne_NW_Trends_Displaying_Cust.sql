
/*********************************************************************************
**																				**
** SR# 9384																		**
** Programmer: James Tuttle		Date: 04/15/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - HVE_Carpet One NW Trends Displaying Cust			**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC HVE_CarpetOne_NW_Trends_Displaying_Cust AS
BEGIN
 SELECT cbcust									AS Cust#
		,cmname									AS Name
		,cbblcd									AS Bill_Code
		,bcdesc									AS [Description]
		,cmslmn									AS Sales#
		,smname									AS Name
		,cmadr1									AS Address1
		,cmadr2									AS Address2		
		,RTRIM(REVERSE(SUBSTRING(REVERSE						-- Split up the City and State since
			(CMADR3),3,LEN(CMADR3))))			AS City			-- the data is stored as one record 
		,REVERSE(LEFT(REVERSE(cmadr3),2))		AS [State]	
		,cmzip									AS Zip
		
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
		
	FROM custmast cm 
	LEFT JOIN custbill cb ON cb.cbcust = cm.cmcust
	LEFT JOIN blcdmast bcm ON bcm.bcblcd = cb.cbblcd
	LEFT JOIN salesman sm ON sm.smno = cm.cmslmn
	
	WHERE cb.cbblcd IN(''1A'', ''1C'', ''1M'', ''1W'')
	')
END

/*----------------------------------------------------------------------------------------------------------
--
MS Access - HVE_CarpetOne_NW_Trends_Displaying_Cust
--
SELECT GSFL2K_CUSTBILL.CBCUST, 
GSFL2K_CUSTMAST.CMNAME AS Customer, 
GSFL2K_CUSTBILL.CBBLCD, 
GSFL2K_CUSTMAST.CMSLMN, 
GSFL2K_CUSTMAST.CMADR1, 
GSFL2K_CUSTMAST.CMADR2, 
GSFL2K_CUSTMAST.CMADR3, 
GSFL2K_CUSTMAST.CMZIP
FROM ((GSFL2K_CUSTBILL INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_CUSTBILL.CBCUST = GSFL2K_CUSTMAST.CMCUST) 
INNER JOIN GSFL2K_BLCDMAST ON GSFL2K_CUSTBILL.CBBLCD = GSFL2K_BLCDMAST.BCBLCD) 

WHERE (((GSFL2K_CUSTBILL.CBBLCD)="1A" 
	Or (GSFL2K_CUSTBILL.CBBLCD)="1C" 
	Or (GSFL2K_CUSTBILL.CBBLCD)="1M" 
	Or (GSFL2K_CUSTBILL.CBBLCD)="1W"));
----------------------------------------------------------------------------------------------------------*/