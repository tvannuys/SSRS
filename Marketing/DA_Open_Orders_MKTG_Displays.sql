/*********************************************************************************
**																				**
** SR# 9393																		**
** Programmer: James Tuttle			Date:05/02/2013								**
** ---------------------------------------------------------------------------- **
** Purpose: From MS Acces - DA_Open Orders_MKTG_Displays						**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC DA_Open_Orders_MKTG_Displays AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohotyp
		,MONTH(ohodat) || ''/'' || DAY(ohodat) || ''/'' || YEAR(ohodat) as oDt
		,ohvia
		,olord#
		,cmcust
		,cmname
		,olitem
		,oldesc
		,oliloc
		,olqord
		,olqbo
		,MONTH(ohsdat) || ''/'' || DAY(ohsdat) || ''/'' || YEAR(ohsdat) as sDt
		,cmslmn AS SalesNbr
		,smname AS SalesPerson
	FROM oohead oh
	LEFT JOIN ooline ol ON (oh.ohco = ol.olco
						AND oh.ohloc = ol.olloc
						AND oh.ohord# = ol.olord#
						AND oh.ohrel# = ol.olrel#
						AND oh.ohcust = ol.olcust)
	LEFT JOIN custmast cm ON oh.ohcust = cm.cmcust
	LEFT JOIN salesman sm ON sm.smno = cm.cmslmn
	
	WHERE oh.ohotyp = ''DP''
		AND ol.olico = 1
		
	ORDER BY oh.ohord#
	')
END


/*-------------------------------------------------------------------------------------------------------------------------------
SELECT GSFL2K_OOHEAD.OHOTYP, 
		GSFL2K_CUSTMAST.CMSLMN, 
		GSFL2K_OOHEAD.OHODAT AS [Order Date], 
		GSFL2K_OOHEAD.OHVIA, 
		GSFL2K_OOLINE.[OLORD#] AS [Order Nbr], 
		GSFL2K_CUSTMAST.CMCUST, 
		GSFL2K_CUSTMAST.CMNAME, 
		GSFL2K_OOLINE.OLITEM AS [Item Nbr], 
		GSFL2K_OOLINE.OLDESC AS [Item Desc], 
		GSFL2K_OOLINE.OLILOC AS [Inventory Loc], 
		GSFL2K_OOLINE.OLQORD AS [Qty Ordered], 
		GSFL2K_OOLINE.OLQBO AS [Qty B/O], 
		GSFL2K_OOHEAD.OHSDAT AS [Ship Date]
		
FROM GSFL2K_ITEMMAST INNER JOIN 
  ((GSFL2K_OOHEAD INNER JOIN GSFL2K_OOLINE ON (GSFL2K_OOHEAD.[OHREL#] = GSFL2K_OOLINE.[OLREL#]) 
		AND (GSFL2K_OOHEAD.[OHORD#] = GSFL2K_OOLINE.[OLORD#]) 
		AND (GSFL2K_OOHEAD.OHLOC = GSFL2K_OOLINE.OLLOC)) 
	INNER JOIN GSFL2K_CUSTMAST ON GSFL2K_OOHEAD.OHCUST = GSFL2K_CUSTMAST.CMCUST) 
ON GSFL2K_ITEMMAST.IMITEM = GSFL2K_OOLINE.OLITEM

WHERE (((GSFL2K_OOHEAD.OHOTYP)="DP") AND ((GSFL2K_OOLINE.OLICO)=1));
-------------------------------------------------------------------------------------------------------------------------------*/