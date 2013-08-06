/*********************************************************************************
**																				**
** SR# 12847																	**
** Programmer: James Tuttle			Date:07/25/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:																		**
**										**
**										**
**										**
**										**
**										**
**********************************************************************************/

ALTER PROC JT_SA_DP_ShippedList AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohco AS Co
		,ohloc	AS Loc
		,ohord#	AS Order
		,ohrel#	AS Rel
		,cmname AS Customer
		,MONTH(ohsdat) || ''/'' || DAY(ohsdat) || ''/'' || YEAR(ohsdat) AS ShipDate
		,ohpo#	AS PO
		,ohvia	AS Via
		,ohotyp	AS Type
		,olitem AS Sku
		,olpric AS ItemPrice
		,olcost AS ItemCost
		,ohtotl AS OrderAmount

	FROM oohead oh
	LEFT JOIN ooline ol ON (ol.olco = oh.ohco
						AND ol.olloc = oh.ohloc
						AND ol.olord# = oh.ohord#
						AND ol.olrel# = oh.ohrel#
						AND ol.olcust = oh.ohcust)
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
	LEFT JOIN itemmast im ON im.imitem = ol.olitem
	
	WHERE oh.ohotyp IN (''SA'',''DP'')
		AND ol.olinvu = ''T''
		AND ol.olpric != ol.olcost
	
	ORDER BY ohco
			,ohloc
			,ohotyp
	
	')
END