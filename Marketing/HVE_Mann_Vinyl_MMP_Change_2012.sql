/*********************************************************************************
**																				**
** SR# 9381																		**
** Programmer: James Tuttle	Date: 04/08/2013									**
** ---------------------------------------------------------------------------- **
** Purpose: MS Access - HVE_Mann Vinyl MMP Change 2012							**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC HVE_Mann_Vinyl_MMP_Change_2012 AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT cbcust
		,cmname
		,cbblcd
		,cmslmn
		,cmadr1
		,cmadr2
		,cmadr3
		,cmzip
		
	FROM custmast cm
	LEFT JOIN custbill cb ON cb.cbcust = cm.cmcust
	LEFT JOIN blcdmast bcm ON bcm.bcblcd = cb.cbblcd
	LEFT JOIN custcont cc ON cc.ccncus = cm.cmcust
	
	WHERE cb.cbblcd = ''MM''
	')
END


/*-------------------------------------------------------------------------------------
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
INNER JOIN GSFL2K_CUSTCONT ON GSFL2K_CUSTMAST.CMCUST = GSFL2K_CUSTCONT.CCNCUS

WHERE (((GSFL2K_CUSTBILL.CBBLCD)="MM"));
-------------------------------------------------------------------------------------*/