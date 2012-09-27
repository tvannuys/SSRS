
--CREATE PROC JT_irr_past_due_2days AS

/* ---------------------------------------------------------*
**  James Tuttle 5/13/2011									*
**  Created Date: 02/18/2009								*
** ---------------------------------------------------------*
** 	Report is looking at account IRR 1 & 2 for 	orders		*
**     that are two days past shipdate and not in shipped   *
**     status.												*
**															*
**----------------------------------------------------------*
*/

-- Query
SELECT ohco 'Company',
	ohloc 'Location',
	ohsdat 'Ship Date',
	ohcust 'Customer #',
	ohcont 'Contact',
	ohord# 'Order #',
	ohrel# 'Release #',
	ohpo# 'PO #',
	olsrl1 'Serial #',
	olitem 'Item',
	oldesc 'Description'
	

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead INNER JOIN ooline ON ohco = olco
	AND ohloc = olloc
	AND ohord# = olord#
	AND ohrel# = olrel#
WHERE ohcust IN(''IRR1'', ''IRR2'', ''IRR3'')
	AND olinvu != ''T''
	AND ohsdat < (CURRENT_DATE - 2 DAYS)	
')
ORDER BY ohco, ohloc, ohcust ;



