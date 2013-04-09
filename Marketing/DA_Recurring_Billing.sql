/*********************************************************************************
**																				**
** SR# 9572																		**
** Programmer: James Tuttle	Date: 04/08/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:		MS Access Query :: DA_Recurring Billing query					**
**																				**
**																				**
**																				**
**																				**
**																				**	
**********************************************************************************/

ALTER PROC DA_Recurring_Billing AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT cmadr3
		,rlcust
		,cmname
		,rlseq#
		,rlitem
		,rldesc
		,rliloc
		,rlqty
		,rlpric
		,rlcost
	FROM custmast cm 
	RIGHT JOIN rbline rb ON rb.rlcust = cm.cmcust
	')
END

/*-------------------------------------------------------------------
-- MS Access Query :: DA_Recurring Billing query
--
SELECT GSFL2K_CUSTMAST.CMADR3,
 GSFL2K_RBLINE.RLCUST, 
 GSFL2K_CUSTMAST.CMNAME, 
 GSFL2K_RBLINE.[RLSEQ#], 
 GSFL2K_RBLINE.RLLSEQ, 
 GSFL2K_RBLINE.RLITEM, 
 GSFL2K_RBLINE.RLDESC, 
 GSFL2K_RBLINE.RLILOC, 
 GSFL2K_RBLINE.RLQTY, 
 GSFL2K_RBLINE.RLPRIC, 
 GSFL2K_RBLINE.RLCOST
FROM GSFL2K_RBLINE INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_RBLINE.RLCUST = GSFL2K_CUSTMAST.CMCUST;
*/