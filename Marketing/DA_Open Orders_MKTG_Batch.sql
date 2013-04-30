
/*********************************************************************************
**																				**
** SR# 9392																		**
** Programmer: James Tuttle		Date: 04/29/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:	From MS Access - DA_Open Orders_MKTG_Batch							**
**																				**
** ADDED: PARM 	@Item DEFAULT "GACRYSTALHANDSET"								**
**																				**
**																				**
**																				**
**********************************************************************************/

CREATE PROC DA_Open_Orders_MKTG_Batch AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohodat AS Order_Date
		,ohvia AS Via
		,ohotyp AS Order_Type
		,olord# AS Order_Nbr
		,cmcust AS Cust_Nbr
		,cmname AS Cust_Name
		,olitem AS Item
		,oldesc AS description
		,oliloc AS Inv_Loc
		,olqord AS Qty_Ordered
		,olqbo AS Qty_BO
		,cmslmn AS SalesPerson
		,ohsdat	AS Ship_Date
		
	FROM oohead oh
	LEFT JOIN ooline ol ON (oh.ohco = ol.olco
						AND oh.ohloc = ol.olloc
						AND oh.ohord# = ol.olord#
						AND oh.ohrel# = ol.olrel#
						AND oh.ohcust = ol.olcust)
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
	LEFT JOIN Itemmast im ON im.imitem = ol.olitem
	
	WHERE oh.ohotyp = ''SA''
		AND olico = 1
		AND ol.olitem = ''''' + ''''' + ' + @Item + ''''' + '''''
	')
END
-----------------------------------------------------------------------------------------------------------------------------------
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
		GSFL2K_OOHEAD.OHSDAT AS [Ship Date]
FROM GSFL2K_ITEMMAST 
INNER JOIN ((GSFL2K_OOHEAD 
INNER JOIN GSFL2K_OOLINE ON (GSFL2K_OOHEAD.OHLOC = GSFL2K_OOLINE.OLLOC) 
	AND (GSFL2K_OOHEAD.[OHORD#] = GSFL2K_OOLINE.[OLORD#]) 
	AND (GSFL2K_OOHEAD.[OHREL#] = GSFL2K_OOLINE.[OLREL#])) 
INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_OOHEAD.OHCUST = GSFL2K_CUSTMAST.CMCUST) 
ON GSFL2K_ITEMMAST.IMITEM = GSFL2K_OOLINE.OLITEM
WHERE (((GSFL2K_OOHEAD.OHOTYP)="SA") 
	AND ((GSFL2K_OOLINE.OLITEM)="GACRYSTALHANDSET") 
	AND ((GSFL2K_OOLINE.OLICO)=1));
-----------------------------------------------------------------------------------------------------------------------------------