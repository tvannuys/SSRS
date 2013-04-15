USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[HVE_email_addresses_all]    Script Date: 04/09/2013 07:07:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HVE_email_addresses_all]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************
**																				**
** SR# 9389																		**
** Programmer: James Tuttle		DATE: 04/08/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:		From the MS Access: HVE_email addresses all						**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC  [dbo].[HVE_email_addresses_all] AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	''SELECT CCNCUS AS Cust_Nbr
		,CMNAME AS Cust_Name
	 	,CEXCLASS AS Cust_Type_Code	 
	 	,CCLDESC AS Cust_Type_Desc	 
		,CMSLMN AS SalesMan#
		,SMNAME AS SalesManName
		,CCNPOR AS PlaceOrder
		,CCNCNT AS Contact
		,CCNTTL AS Contact_Title
		,CCNPHN AS Phone
		,CCNEXT AS Extension
		,CCNE_MAIL AS E_Mail_Addr
		,CMLOC AS CustLoc
	FROM custcont cc 
	INNER JOIN custmast cm ON cc.ccncus = cm.cmcust
	LEFT JOIN custextn cxt ON cxt.cexcust = cc.ccncus
	LEFT JOIN cuclmast clm ON clm.cclclass = cxt.cexclass
	INNER JOIN salesman sm ON (cm.cmslmn = sm.smno 
		AND cm.cmslmn = sm.smno)
	WHERE cm.cmco = 1
		AND cc.ccnplemail = ''''Y''''
	'')
END


/*
-- MS Access Code
--
SELECT * FROM OPENQUERY(GSFL2K,''
SELECT GSFL2K_CUSTCONT.CCNCUS AS [Cust Nbr], 
GSFL2K_CUSTMAST.CMNAME AS [Cust Name], 
[customer class ii codes defined].CEXCLASS AS [Cust Type Code], 
[customer class ii codes defined].CCLDESC AS [Cust Type Desc], 
GSFL2K_CUSTMAST.CMSLMN, 
GSFL2K_SALESMAN.SMNAME, 
GSFL2K_CUSTCONT.CCNPOR, 
GSFL2K_CUSTCONT.CCNCNT AS Contact, 
GSFL2K_CUSTCONT.CCNTTL AS Contact_Title, 
GSFL2K_CUSTCONT.CCNPHN AS Phone, 
GSFL2K_CUSTCONT.CCNEXT AS Extension, 
GSFL2K_CUSTCONT.CCNE_MAIL AS [E-Mail Addr], 
GSFL2K_CUSTMAST.CMLOC
FROM ((GSFL2K_CUSTCONT INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_CUSTCONT.CCNCUS = GSFL2K_CUSTMAST.CMCUST) 
	INNER JOIN [customer class ii codes defined] ON GSFL2K_CUSTCONT.CCNCUS = [customer class ii codes defined].CEXCUST) 
	INNER JOIN GSFL2K_SALESMAN ON (GSFL2K_CUSTMAST.CMSLMN = GSFL2K_SALESMAN.SMNO) AND (GSFL2K_CUSTMAST.CMSLMN = GSFL2K_SALESMAN.SMNO)
WHERE (((GSFL2K_CUSTMAST.CMCO)=1) AND ((GSFL2K_CUSTCONT.CCNPLEMAIL)="Y"))'');

*/
' 
END
GO


