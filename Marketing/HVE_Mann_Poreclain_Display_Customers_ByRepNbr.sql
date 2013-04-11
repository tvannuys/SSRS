/*********************************************************************************
**																				**
** SR# 9784																		**
** Programmer: James Tuttle		Date:04/11/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:		from MS Access - HVE_Mann Poreclain Display Customers_KEN TAYLOR**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC HVE_Mann_Poreclain_Display_Customers_ByRepNbr
	@Salesman varchar(3)	
	
AS
BEGIN
DECLARE @sql varchar(3000)
SET @sql = '

 SELECT cbcust																AS Cust_Nbr
		,cmname																AS Customer
		,cbblcd																AS BillCode
		,bcdesc																AS Description
		,cmslmn																AS Salesman
		,smname																AS Name
		,cmadr1																AS Address1
		,cmadr2																AS Address2
		,UPPER(RTRIM(REVERSE(SUBSTRING(REVERSE(cmadr3),3,LEN(cmadr3)))))	AS City		/*  Seperate City and Zip that is stored as */
		,UPPER(REVERSE(LEFT(REVERSE(cmadr3),2)))							AS [State]	/* one field from the field [cmadr3]		*/
		,cmzip																AS Zip	
		
 FROM OPENQUERY(GSFL2K,	
	''SELECT cbcust 
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
	
	WHERE (cb.cbblcd = ''''PS''''
		 OR cb.cbblcd = ''''PU''''
		 OR cb.cbblcd = ''''23'''' 
		 OR cb.cbblcd = ''''49'''' 
		 OR cb.cbblcd = ''''61''''
		 OR cb.cbblcd = ''''PR'''' 
		 OR cb.cbblcd = ''''PQ'''' 
		 OR cb.cbblcd = ''''AG'''' 
		 OR cb.cbblcd = ''''35'''' 
		 OR cb.cbblcd = ''''38'''' 
		 OR cb.cbblcd = ''''39'''' 
		 OR cb.cbblcd = ''''51'''' 
		 OR cb.cbblcd = ''''52'''' 
		 OR cb.cbblcd = ''''53'''' 
		 OR cb.cbblcd = ''''63'''' 
		 OR cb.cbblcd = ''''64'''' 
		 OR cb.cbblcd = ''''65'''' 
		 OR cb.cbblcd = ''''77''''  )
	  AND cm.cmslmn = ' + '' + @Salesman + '' + '
	'')'
END
EXEC(@sql)
GO

/* HVE_Mann_Poreclain_Display_Customers_ByRepNbr 609	*/

/*------------------------------------------------------------------------------------------------------------------------------------
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
WHERE (((GSFL2K_CUSTBILL.CBBLCD)="PS" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="PU" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="23" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="49" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="61" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="PR" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="PQ" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="AG" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="35" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="38" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="39" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="51" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="52" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="53" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="63" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="64" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="65" 
		Or (GSFL2K_CUSTBILL.CBBLCD)="77") 
	AND ((GSFL2K_CUSTMAST.CMSLMN)=609));	<------------- Need as a PARM <<<<

------------------------------------------------------------------------------------------------------------------------------------*/