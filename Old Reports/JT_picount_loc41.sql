
--CREATE PROC JT_picount_loc41 AS

/* -----------------------------------------------------*
** James Tuttle 5/13/2011								*
** -----------------------------------------------------*
** 	Report is counts the number of lines that had been	*
**   Cycle Counted the prior day						*
**   
**------------------------------------------------------*
*/


-- Query
SELECT MIN(pchdate) 'Date',
	(pchpuser) 'User',
	COUNT(pchitem) 'Total Lines Counted by User'
	
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM picounthst
WHERE pchloc = 41
	AND pchdate = (CURRENT_DATE - 1 DAYS)
')
Group BY pchpuser

-- END Query
