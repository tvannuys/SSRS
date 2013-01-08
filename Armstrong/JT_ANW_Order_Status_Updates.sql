
----------------------------------------------------------------------
--
--	SR# 5370
--	James Tuttle
--	11/15/2012 
--
--	PURPOSE:  Run query to check on shipments and report on
--	those shipments with the order status and any routing.
--  ** The Bill To Account is: 4100000 **
--
--
----------------------------------------------------------------------
--ALTER PROC JT_ANW_Order_Status_Updates AS
 BEGIN
	SELECT DISTINCT *
	FROM OPENQUERY(GSFL2K,
		'SELECT ohord# AS Order#
				,ohrel# AS Rel#
				,ohvia AS Via
				,ortrt AS Route
				,rtdesc AS Description
				,MONTH(ortsdt) || ''/'' || DAY(ortsdt) || ''/'' || YEAR(ortsdt) AS Ship_Date
				,MONTH(ortadt) || ''/'' || DAY(ortadt) || ''/'' || YEAR(ortadt) AS Arrive_Date
				,otcmt1 AS Sidemark
		FROM oohead oh
		JOIN ooline ol ON (oh.ohco = ol.olco
								AND oh.ohloc = ol.olloc
								AND oh.ohord# = ol.olord#
								AND oh.ohrel# = ol.olrel#
								AND oh.ohcust = ol.olcust)	
		JOIN ooroute rt ON (oh.ohco = rt.ortco
								AND oh.ohloc = rt.ortloc
								AND oh.ohord# = rt.ortord
								AND oh.ohrel# = rt.ortrel
								AND oh.ohcust = rt.ortcus)
		JOIN route rte ON rt.ortrt = rte.rtrout
		LEFT JOIN ootext ot ON		
 			( oh.ohco = ot.otco
				AND oh.ohloc = ot.otloc
				AND oh.ohord# = ot.otord#
				AND oh.ohrel# = ot.otrel#
				AND oh.ohcust = ot.otcust
				AND otseq# = 0 AND ottseq = 1)
				
		WHERE oh.ohbil# = ''4100000''
			AND ol.olinvu != ''T''
		ORDER BY oh.ohord#
				
		')
END
	