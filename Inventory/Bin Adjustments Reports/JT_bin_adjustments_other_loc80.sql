
--CREATE PROC JT_bin_adjustments_other_loc80 AS

/* -----------------------------------------------------*
** James Tuttle 6/3/2011								*
** -----------------------------------------------------*
** 	Report is Get adjustments made that are not in a 	*
**  list for Loc 80:									*
**	50 51 52 53 54 DC 56 57 AA PI 25 38 39				*
**------------------------------------------------------*
*/


-- Query
SELECT irloc 'Location',
	irreason 'Reason Code',
	irdate 'Date',
	iritem 'Item',
	irdesc 'Description',
	irbin 'Bin',
	irqty 'QTY',
	iruser 'User',
	ircomt 'Comment'
	
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM itemrech
WHERE irloc = 80
	AND irsrc IN(''B'', ''A'', ''M'', ''I'')
	AND irreason NOT IN(''50'',''52'',''51'',''53'',''54'',''DC'',''56'',''57'',''AA'',''PI'',''25'',''38'',''39'')
	AND irdate = (CURRENT_DATE - 1 DAYS)	
')

ORDER BY irreason

-- END Query
