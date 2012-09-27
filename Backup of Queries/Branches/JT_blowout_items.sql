

--CREATE PROC JT_blowout_items AS

/* ---------------------------------------------------------*
** James Tuttle 5/10/2011									*
** ---------------------------------------------------------*
** Report on any items that have a serial # Like 'BLOWOUT'	*
**															*
**----------------------------------------------------------*
*/

-- Query
SELECT idloc 'Location',
	iditem 'Item',
	imdesc 'Description',
	idqoh 'QOH',
	idbin 'Bin'

-- Check for the Serail # LIKE 'BLOWOUT'
FROM OPENQUERY (GSFL2K, '
SELECT * 
FROM itemdetl id INNER JOIN itemmast im ON imitem=iditem
WHERE idserl LIKE ''%BLOWOUT%'' 
	AND idqoh > 0
')

ORDER BY iditem ;

-- END --