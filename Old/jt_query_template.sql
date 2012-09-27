/* -----------------------------------------------------*
** James Tuttle 4/26/2011								*
** -----------------------------------------------------*
** Report on inventory that is							*
** not committed in a stage/ship type					*
** bin location at any location							*
** based off the bin location's "section' = XXXXX		*
**------------------------------------------------------*
*/

SELECT idloc, iditem, idbin, blgrp, idqoh, idqoo
FROM OPENQUERY (GSFL2K, 'select * from itemdetl id INNER JOIN binloc bl ON idbin = blbin AND idloc = blloc
WHERE idqoh > 0 AND idqoo <= 0 AND blgrp IN (''XXXXX'', ''WCSTG'')')





