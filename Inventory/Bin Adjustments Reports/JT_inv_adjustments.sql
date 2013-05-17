
ALTER PROC JT_inv_adjustments AS

/* -----------------------------------------------------*
** James Tuttle 5/10/2011		Created: 10/09/2008		*
** -----------------------------------------------------*
** 	Report is looking at adjustments by reason codes	*
**														*
**------------------------------------------------------*
*/
--SET STATISTICS TIME ON
--========================================================
-- James Tuttle  Date:05/16/2013
-- SR# 10886
--========================================================
-- Query
SELECT irloc 'Location',
	irreason 'Adj Code',
	irdate 'Date',
	iritem 'item',
	irdesc 'Description',
	irbin 'Bin',
	ircomt 'Comments',
	irqty 'QTY',
	ircost 'Cost',
	iruser 'User',
	CAST((irqty * ircost)AS DECIMAL(18,5)) 'Total Cost' 
-- Select Adjustmenr reason codes
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM itemrech
WHERE irreason IN(''02'', ''25'', ''16'', ''38'', ''39'', ''PI'', ''52'')
	AND irdate = (CURRENT_DATE - 1 DAY)
	AND irqty > 0
')

ORDER BY irloc, irreason ASC ;

-- END Query