

ALTER PROC [dbo].[JT_non_stock_returns] AS

/* -----------------------------------------------------*
** James Tuttle 6/3/2011		Created: 11/12/2008		*
** -----------------------------------------------------*
** 	Report is Non Stock from returns					*
**------------------------------------------------------*
--======================================================
-- 05/10/12 JAMEST
-- Added User to the list per Colleen B
--======================================================
*/


-- Query
SELECT ohco 'Co',
	ohloc 'Loc',
	ohord# 'Order',
	ohuser 'User',
	olitem 'Item',
	oldesc 'Description',
	olqshp 'QTY',
	olbinl 'Bin',
	imdrop 'Drop?',
	imsi 'Stock?'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead INNER JOIN ooline ON ohco = olco
	AND ohloc = olloc
	AND ohord# = olord#
	AND ohrel# = olrel#
INNER JOIN itemmast ON olitem = imitem
WHERE ohcm = ''Y''
	AND olqshp < 0.00
	AND imsi = ''N''
	AND ohjobt != ''XX''
	AND ohuser NOT IN (''MONICAM'',''KIME'')
')

ORDER BY ohloc

-- END Query
GO


