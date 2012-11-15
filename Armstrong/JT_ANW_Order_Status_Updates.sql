
----------------------------------------------------------------------
--
--	SR# 5370
--	James Tuttle
--	11/15/2012 
--
--	PURPOSE:  Run query to check on shipments and report on
--	those shipments with the order status and any routing.
--
--
--
----------------------------------------------------------------------

--CREATE PROC JT_ANW_Order_Status_Updates AS
SELECT *
FROM OPENQUERY(GSFL2K,
	'SELECT ohord#
			,ohrel#
			,ohvia
			,ohrout
			,ohsdat
	FROM oohead oh
	JOIN ooline ol ON (ol.olco = oh.ohco
						ol.olloc = oh.ohloc
						ol.olord# = oh.ohord#
						ol.olrel# = oh.ohrel#
						ol.olcust = oh.ohcust)
	WHERE
	')
	