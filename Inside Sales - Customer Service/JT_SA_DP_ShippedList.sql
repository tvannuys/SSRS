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
		,ohtotl AS Amount

	FROM oohead oh
	LEFT JOIN ooline ol ON (ol.olco = oh.ohco
						AND ol.olloc = oh.ohloc
						AND ol.olord# = oh.ohord#
						AND ol.olrel# = oh.ohrel#
						AND ol.olcust = oh.ohcust)
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
	
	WHERE oh.ohotyp IN (''SA'',''DP'')
		AND ol.olinvu = ''T''
	
	ORDER BY ohco
			,ohotyp
	
	')
END