/****************************************************************
* Programmer: James Tuttle		Date:06/12/2012					*
*																*
* Report for Eddie T and Mary N:								*
* Purpose: to look at the routes for all co and loc to see		*	
*  what the weights are at 3pm instead of later in the night	*
*																*
*****************************************************************/


-- CREATE PROC JT_daily_eastbound_truck_weight AS
-- BEGIN
SELECT * 
FROM OPENQUERY(GSFL2K,
	'SELECT olico
			,oliloc
			,olord#
			,olrel#
			,olitem
			,ohrout
			,olqshp
			,imwght
			,SUM(olqshp * imwght) AS WEGHT
	FROM ooline ol
	JOIN oohead oh
		ON (ol.olco = oh.ohco
			AND ol.olloc = oh.ohloc
			AND ol.olord# = oh.ohord#
			AND ol.olrel# = oh.ohrel#
			AND ol.olcust = olcust)
	JOIN itemmast im
		ON ol.olitem = im.imitem
	WHERE oh.ohrout IN (''50-14'',''41-14'',''57-14'')
		AND ol.oliloc IN (50,41,57,52)
		AND oh.ohcrhl != ''Y''
		AND ol.olbyp != ''B''
	GROUP BY olico
			,oliloc
			,olord#
			,olrel#
			,olitem
			,imwght
			,olqshp
			,ohrout
	ORDER BY olico
			,oliloc
			,olord#
			,olrel#
	')
--END