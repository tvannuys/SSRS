
/*********************************************************************************
**																				**
** SR# 9390																		**
** Programmer: James Tuttle	Date:	04/25/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - HVE_Carpet1_CCA_Buy_Group_Cust						**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC  HVE_Carpet1_CCA_Buy_Group_Cust AS
BEGIN
 SELECT cmdelt 
		,cgcust									AS Cust#
		,cgseq#									AS Seq#
		,cmname									AS CustName
		,cmloc									AS loc
		,cmadr1									AS Address1
		,cmadr2									AS Address2
		,RTRIM(REVERSE(SUBSTRING(REVERSE(
				cmadr3),3,LEN(cmadr3))))		AS City			-- Seperate City and State since the DB2 stores as one
		,REVERSE(LEFT(REVERSE(cmadr3),2))		AS [State]		-- Seperate City and State since the DB2 stores as one
		,STUFF(cmzip,6,0,'-')					AS Zip			-- Format zip as 12345-1234
		,cmphon									
		,STUFF(STUFF(cmphon,4,0,'-'),8,0,'-')	AS Phone		-- Format with dashes for a phone number format
		,STUFF(STUFF(cmfax,4,0,'-'),8,0,'-')	AS Fax			-- Format with dashes for a phone number format				
		,smno									AS SalesNbr
		,smname									AS Name
		,cgbgrp									AS BuyGrp
		,cexclass								AS CustType
		,ccldesc								AS [Description]
		,cgffmc									AS FRMfm
		,cgtfmc									AS TOfm
		,cgcode									AS CBG
		
 FROM OPENQUERY(GSFL2K,	
	'SELECT cmdelt 
		,cgcust
		,cgseq# 
		,cmname
		,cmloc 
		,cmadr1 
		,cmadr2 
		,cmadr3
		,cmzip
		,cmphon
		,cmfax
		,smname
		,cgbgrp
		,cexclass
		,ccldesc
		,cgffmc
		,cgtfmc
		,smno
		,cgcode
		
	FROM custmast cm
	LEFT JOIN custbgrp cbg ON cbg.cgcust = cm.cmcust
	LEFT JOIN salesman sm ON sm.smno = cm.cmslmn
	LEFT JOIN custextn cxt ON cxt.cexcust = cbg.cgcust
	LEFT JOIN cuclmast clm ON clm.cclclass = cxt.cexclass
	
	WHERE ((cbg.cgbgrp = ''CARPERT1'')
		OR (cbg.cgbgrp = ''CCA''))
	')
END





/*-------------------------------------------------------------------------------------------------------------------------------------
SELECT GSFL2K_CUSTMAST.CMDELT, 
		 GSFL2K_CUSTBGRP.CGCUST AS [Cust Nbr],
		 GSFL2K_CUSTBGRP.[CGSEQ#], 
		 GSFL2K_CUSTMAST.CMNAME AS [Cust Name], 
		 GSFL2K_CUSTMAST.CMLOC, 
		 GSFL2K_CUSTMAST.CMADR1 AS [Addr 1],
		 GSFL2K_CUSTMAST.CMADR2 AS [Addr 2],
		 GSFL2K_CUSTMAST.CMADR3 AS [City & State], 
		 GSFL2K_CUSTMAST.CMZIP AS Zip, 
		 GSFL2K_CUSTMAST.CMPHON AS Phone, 
		 GSFL2K_CUSTMAST.CMFAX AS Fax, 
		 GSFL2K_SALESMAN.SMNAME AS Salesman, 
		 GSFL2K_CUSTBGRP.CGBGRP AS [Buying Group], 
		 GSFL2K_CUSTEXTN.CEXCLASS AS [Cust Type],
		 GSFL2K_CUCLMAST.CCLDESC AS [Cust Type Desc],
		 GSFL2K_CUSTBGRP.CGFFMC, 
		 GSFL2K_CUSTBGRP.CGTFMC, 
		 GSFL2K_CUSTBGRP.CGLCUS, 
		 GSFL2K_CUSTBGRP.CGLCDT, 
		 GSFL2K_SALESMAN.SMNO, 
		 GSFL2K_CUSTBGRP.CGCODE
		 
FROM (((GSFL2K_CUSTMAST 
INNER JOIN GSFL2K_CUSTBGRP ON GSFL2K_CUSTMAST.CMCUST = GSFL2K_CUSTBGRP.CGCUST) 
INNER JOIN GSFL2K_SALESMAN ON GSFL2K_CUSTMAST.CMSLMN = GSFL2K_SALESMAN.SMNO) 
INNER JOIN GSFL2K_CUSTEXTN ON GSFL2K_CUSTBGRP.CGCUST = GSFL2K_CUSTEXTN.CEXCUST) 
INNER JOIN GSFL2K_CUCLMAST ON GSFL2K_CUSTEXTN.CEXCLASS = GSFL2K_CUCLMAST.CCLCLASS

WHERE (((GSFL2K_CUSTBGRP.CGBGRP)="CARPET1" Or (GSFL2K_CUSTBGRP.CGBGRP)="CCA"));
-------------------------------------------------------------------------------------------------------------------------------------*/