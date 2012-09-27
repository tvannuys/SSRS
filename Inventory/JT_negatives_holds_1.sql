 
--CREATE PROC JT_negatives AS

/* -----------------------------------------------------*
** James Tuttle 5/4/2011								*
** -----------------------------------------------------*
** 	Report is looking for negative inventory from		*
**	  the detail file									*
**------------------------------------------------------*
*/

-- Query
SELECT idloc 'Location',
iditem 'Item',
idky 'Tag#',
idserl 'Serial',
idbin 'Bin',
idohbl 'On Hand',
idqoh 'QOH'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM itemdetl id
JOIN itembal ib
	ON id.iditem = ib.item
WHERE id.idohbl < -.08
	OR id.idqoh < -.08
	OR ib.ib
')
	
ORDER BY idloc ASC, iditem ASC

-- END Query