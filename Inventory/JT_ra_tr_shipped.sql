/* -----------------------------------------------------*
** James Tuttle 5/4/2011								*
** -----------------------------------------------------*
** 	Report is looking for Returns in Shipped Status 	*
**    and Transfers in Shipped Status					*
**------------------------------------------------------*
*/

-- Query
SELECT ohloc 'Location',
ohord# 'Order',
ohrel# 'Release',
ohotyp 'Order Type'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead 
INNER JOIN ooline
	ON ohco=ohco 
	AND ohloc=olloc 
	AND ohord#=olord#
	AND ohrel#=olrel#
WHERE ohotyp IN (''RA'', ''TR'')
	AND olinvu = ''T''')
	
ORDER BY ohloc ASC

-- END Query

