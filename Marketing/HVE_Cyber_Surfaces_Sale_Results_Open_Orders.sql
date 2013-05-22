/*********************************************************************************
**																				**
** SR# 9388																		**
** Programmer: James Tuttle				Date:04/25/2013							**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - HVE_Cyber-Surfaces Sale Results Open Orders		**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC HVE_Cyber_Surfaces_Sale_Results_Open_Orders 
	@OrderType varchar(2)
AS
BEGIN
DECLARE @sql varchar(4000)
SET @sql = '
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	''SELECT MONTH(ohodat) || ''''/'''' || DAY(ohodat) || ''''/'''' || YEAR(ohodat) AS oDt
		,ohvia AS Via
		,ohotyp AS Order_Type
		,olord# AS Order_Nbr
		,cmcust AS Cust_Nbr
		,cmname AS Cust_Name
		,olitem AS Item_Nbr
		,oldesc AS Description
		,oliloc AS Inv_Loc
		,olqord AS Qty_Ord
		,olqbo AS Qty_BO
		,cmslmn AS Salesman
		,MONTH(ohsdat) || ''''/'''' || DAY(ohsdat) || ''''/'''' || YEAR(ohsdat) AS sDt
		,oleprc AS SubTotal
		
	FROM oohead oh
	LEFT JOIN ooline ol ON (ol.olco = oh.ohco
						AND ol.olloc = oh.ohloc
						AND ol.olord# = oh.ohord#
						AND ol.olrel# = oh.ohrel#)
	LEFT JOIN itemmast im ON ol.olitem = im.imitem
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
	
	WHERE oh.ohotyp = UPPER(' + '''' + '''' + @OrderType + '''' + '''' + ')
		AND ol.olico = 1
	'')'
END
EXEC(@sql)


--  HVE_Cyber_Surfaces_Sale_Results_Open_Orders 'su'
 

/*-------------------------------------------------------------------------------------------------------------------------------------------
SELECT GSFL2K_OOHEAD.OHODAT AS [Order Date],
	 GSFL2K_OOHEAD.OHVIA, 
	 GSFL2K_OOHEAD.OHOTYP, 
	 GSFL2K_OOLINE.[OLORD#] AS [Order Nbr],
	  GSFL2K_CUSTMAST.CMCUST, 
	  GSFL2K_CUSTMAST.CMNAME, 
	  GSFL2K_OOLINE.OLITEM AS [Item Nbr], 
	  GSFL2K_OOLINE.OLDESC AS [Item Desc], 
	  GSFL2K_OOLINE.OLILOC AS [Inventory Loc], 
	  GSFL2K_OOLINE.OLQORD AS [Qty Ordered], 
	  GSFL2K_OOLINE.OLQBO AS [Qty B/O], 
	  GSFL2K_CUSTMAST.CMSLMN, 
	  GSFL2K_OOHEAD.OHSDAT AS [Ship Date], 
	  GSFL2K_OOLINE.OLEPRC
	  
FROM GSFL2K_ITEMMAST 
	INNER JOIN ((GSFL2K_OOHEAD INNER JOIN GSFL2K_OOLINE ON (GSFL2K_OOHEAD.OHLOC = GSFL2K_OOLINE.OLLOC) 
		AND (GSFL2K_OOHEAD.[OHORD#] = GSFL2K_OOLINE.[OLORD#])
		 AND (GSFL2K_OOHEAD.[OHREL#] = GSFL2K_OOLINE.[OLREL#])) 
	INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_OOHEAD.OHCUST = GSFL2K_CUSTMAST.CMCUST) ON GSFL2K_ITEMMAST.IMITEM = GSFL2K_OOLINE.OLITEM
	
WHERE (((GSFL2K_OOHEAD.OHOTYP)="SU") AND ((GSFL2K_OOLINE.OLICO)=1));
-------------------------------------------------------------------------------------------------------------------------------------------*/
