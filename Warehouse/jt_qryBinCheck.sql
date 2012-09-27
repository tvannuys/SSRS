
--CREATE PROC JT_BinCheck_v2 AS

/* -----------------------------------------------------*
** James Tuttle 4/26/2011								*
** -----------------------------------------------------*
** Report on inventory that is							*
** not committed in a stage/ship type					*
** bin location at any location							*
** based off the bin location's "section' = XXXXX		*
**------------------------------------------------------*
*/

-- Query
SELECT idco 'Company', 
idloc 'Location', 
iditem 'Item', 
idbin 'Bin', 
blgrp 'Section', 
idqoh 'On Hand'

FROM OPENQUERY (GSFL2K, '
select * 
from itemdetl id INNER JOIN binloc bl ON idbin = blbin AND idloc = blloc
WHERE idqoh > 0.07 
AND idqoo <= 0 
AND blgrp IN (''XXXXX'', ''WCSTG'')')

ORDER BY idloc ASC, idbin ASC;

-- END --