
BEGIN
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohco
			,ohloc
			,ohord#
			,ohrel#
			,ohcrus
			,ohcrdt
			,ohcrtm
			
	FROM oohead
	
	WHERE ohcrus = ''SARAH''
		AND ohcrdt = ''10/08/2013''
		AND ohcrtm >= 160000
	')
END