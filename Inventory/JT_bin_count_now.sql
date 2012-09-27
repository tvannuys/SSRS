CREATE PROC JT_bin_count_now AS

/* -----------------------------------------------------*
** James Tuttle 5/9/2011								*
** -----------------------------------------------------*
** Report on Check for the recount bin flag every hour	*
**	and email to IC Manager - 02/04/2009				*
**------------------------------------------------------*
*/

-- Query
SELECT blloc 'Location',
	blbin 'Bin',
	bldesc 'Description',
	blcur$valu '$ Value',
	blcountnow 'Count Now?',
	blldlc 'Date Last Cnt',
	bllusr 'User Last Cnt'

-- Check for the Flag in the binCountNow Filed = 'Y'
FROM OPENQUERY (GSFL2K, '
SELECT * 
FROM binloc
WHERE blcountnow=''Y''
')

ORDER BY blloc ASC, blbin ASC;

-- END --