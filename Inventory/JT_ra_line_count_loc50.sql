
--CREATE PROC JT_ra_line_count_loc50 AS

/* ---------------------------------------------------------*
**  James Tuttle 5/12/2011									*
** ---------------------------------------------------------*
** 	Report is counting how many RA Lines a User processed	*
**    the prior day at Location 50							*
**															*
**	IRSCR='R'												*
**----------------------------------------------------------*
*/

-- Query
SELECT iruser 'User',
	COUNT(*) '# of RA Lines',
	MIN(irdate) 'Date'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM itemrech
WHERE irloc = 50
	AND irsrc = ''R''
	AND irdate = (CURRENT_DATE - 1 DAYS)	
')
GROUP BY iruser










