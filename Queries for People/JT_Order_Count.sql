
--CREATE PROC JT_Order_Count AS

SELECT COUNT(*)
FROM OPENQUERY(GSFL2K,
	'SELECT olord#, olrel#, ohviac
	FROM ooline JOIN oohead ON ohco = olco
		AND ohloc = olloc
		AND ohord# = olord#
		AND ohrel# = olrel#
	WHERE oliloc = 50
		AND olinvu = ''T''
	GROUP BY olord#, olrel#,ohviac
	ORDER BY ohviac ASC
')
		
		