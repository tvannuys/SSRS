
--CREATE PROC JT_intrans80 AS

/* -----------------------------------------------------*
** James Tuttle 5/4/2011								*
** -----------------------------------------------------*
** 	Report is looking for transfer/orders still 		*
**		in-trans over a week to Anchorage				*
**		They should be received by the 7th day			*
**------------------------------------------------------*
*/

-- No need for variable when done in the SELECT
--DECLARE @ShipDate datetime

--SET @ShipDate = DATEADD(DD,-6,DATEDIFF(DD,0,GETDATE()))


-- Query
SELECT olloc 'Location',
olsdat 'Ship Date',
olord# 'Order',
olrel# 'Release',
olitem 'Item',
olqshp 'Qty Ship',
olrout 'Route',
olinvu 'Invetory Status'

FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead INNER JOIN ooline 
	ON ohco=olco
	AND ohloc=olloc
	AND ohord#=olord#
	AND ohrel#=olrel#
WHERE oliloc = 50
	AND ohrout = ''50-80''
	AND olinvu =''W''
')
WHERE olsdat < DATEADD(DD,-6,DATEDIFF(DD,0,GETDATE()))
--WHERE olsdat < @ShipDate 
ORDER BY olord# ASC

-- END Query