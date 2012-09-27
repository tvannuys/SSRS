
CREATE PROC JT_ra_tr_shipped AS 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* -----------------------------------------------------*
** James Tuttle 5/4/2011								*
** -----------------------------------------------------*
** 	Report is looking for Returns in Shipped Status 	*
**    and Transfers in Shipped Status					*
**------------------------------------------------------*
*/


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	


-- Query
SELECT ohloc 'Location',
ohord# 'Order',
ohrel# 'Release',
ohotyp 'Order Type'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead 
INNER JOIN ooline
	ON ohco=ohco 
	AND ohloc=olloc 
	AND ohord#=olord#
	AND ohrel#=olrel#
WHERE ohotyp IN (''RA'', ''TR'')
	AND olinvu = ''T''')
	
ORDER BY ohloc ASC


-- END --
 

END

