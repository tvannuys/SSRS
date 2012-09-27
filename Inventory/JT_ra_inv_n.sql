
--CREATE PROC JT_inv_n AS
/* -----------------------------------------------------*
** James Tuttle 5/9/2011								*
** -----------------------------------------------------*
** 	Report is looking for Test for the Invenotry Field	*
**      ("I") if equal to "N" on an RA					*
**------------------------------------------------------*
*/

-- Query
SELECT ohco 'Company',
ohloc 'Location',
ohsdat 'Date',
ohord# 'Order',
ohrel# 'Release',
olitem 'Item',
oldesc 'Description',
ohcm 'Credit?',
olbyp 'Inventory?',
oldiv 'Division',
olcls# 'Class#'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead INNER JOIN ooline ON ohco=olco
	AND ohloc=olloc
	AND ohord#=olord#
	AND ohrel#=olrel#
WHERE ohcm=''Y''
	AND olbyp=''N''
	AND ohcred!=''XX''
	AND olcls# NOT BETWEEN 13000 AND 13997
	AND ohotyp NOT IN(''CL'', ''FC'')
')
	
ORDER BY ohloc ASC

-- END Query