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
--
-- SR# 10660  James Tuttle  Date:05/08/2013
--
-- Change the name to Recurring Billing Report
-- Change set-up to have the option of picking 1 or multiple item numbers
-- Remove Cost column	-
-- Remove Seq # column	-
-- Remove Loc column	-
--
---------------------------------------------------------------------------------------

ALTER PROC DA_Recurring_Billing
	 @CSV varchar(100)
AS
BEGIN
 SELECT RTRIM(REVERSE(SUBSTRING					
			(REVERSE(cmadr3),3,LEN(cmadr3))))	AS City
		,REVERSE(LEFT(REVERSE(cmadr3),2))		AS [State]
		,rlcust									AS CustNbr
		,cmname									AS Cust
		,rlitem									AS Item	
		,rldesc									AS [Description]
		,rlqty									AS Qty
		,rlpric									AS Price
		
 FROM OPENQUERY(GSFL2K,	
	'SELECT cmadr3
		,rlcust
		,cmname
		,rlitem
		,rldesc
		,rlqty
		,rlpric

	FROM custmast cm 
	
	RIGHT JOIN rbline rb ON rb.rlcust = cm.cmcust
	')
WHERE rlitem IN (SELECT * FROM dbo.udfCSVToLIst(@CSV))
END

-- DA_Recurring_Billing 'MAASPCER,MAASP,MAASPCOM'



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