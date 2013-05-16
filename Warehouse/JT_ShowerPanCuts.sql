/*********************************************************************************
**																				**
** SR# 10893																	**
** Programmer: James Tuttle	Date:05/16/2013										**
** ---------------------------------------------------------------------------- **
** Purpose:	A report the runs at 5PM to email Jason M and Joe C in vinyl		**
**			can get to see what shower pan orders are open to be cut.			**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_ShowerPanCuts AS
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT olico
		,oliloc
		,MONTH(olsdat) || ''/'' || DAY(olsdat) || ''/'' || YEAR(olsdat) as sDt
		,olrout
		,olord#
		,olitem
		,olqshp
		,olidky
		
	FROM ooline ol
	
	WHERE ol.olitem IN (''NORICHP5'',''NORICHP6'')
		AND ol.olinvu NOT IN (''S'', ''T'',''G'')
		AND ol.oliloc = 50
	')
END