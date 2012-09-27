
--CREATE PROC JT_small_lot_vct_pm AS

/* -----------------------------------------------------*
** James Tuttle 6/24/2011		Created: 6/25/2009		*
** -----------------------------------------------------*
** 	Report is for Mannington VCT will QTY < 6			*
**------------------------------------------------------*
*/


-- Query
SELECT idco 'co',
	idloc 'Loc',
	iditem 'Item',
	idserl 'Serial',
	iddylt 'Dye Lot',
	idbin 'Bin',
	idqoh 'QTY'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM itemdetl
WHERE idcls# = 41040
	AND idqoh BETWEEN 1 AND 5
	AND idqoo = 0
')

ORDER BY idbin

-- END Query