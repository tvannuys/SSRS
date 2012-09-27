
 --CREATE PROC JT_wrong_location_received AS

/* -----------------------------------------------------*
** James Tuttle 5/19/2011		Created: 6/17/2009		*
** -----------------------------------------------------*
** 	Report is to find CO 1 orders received into CO 2	*
**   and CO 2 at Co 1 so it can be corrected			*
**------------------------------------------------------*
*/

----------------------------------*
--								--*
-- UNION all three SELECTS that --*
-- look at oohead locations and --*
-- iloc (inventoried) locations --*
--								--*
----------------------------------*
-- Query
SELECT ohco 'Company',
	ohloc 'Location',
	ohord# 'Order'
	
	
	FROM OPENQUERY (GSFL2K, '
	SELECT *
	FROM oohead INNER JOIN ooline on ohco=olco
		AND ohloc=olloc
		AND ohord#=olord#
		AND ohrel#=olrel#
	WHERE ohco=1
		AND ohloc=50
		AND olico=2
		AND oliloc=42
UNION
	SELECT *
	FROM oohead INNER JOIN ooline on ohco=olco
		AND ohloc=olloc
		AND ohord#=olord#
		AND ohrel#=olrel#
	WHERE ohco=1
		AND ohloc=60
		AND olico=2
		AND oliloc=42
UNION
	SELECT *
	FROM oohead INNER JOIN ooline on ohco=olco
		AND ohloc=olloc
		AND ohord#=olord#
		AND ohrel#=olrel#
	WHERE ohco=2
		AND ohloc=42
		AND olico=1
		AND oliloc=60
')

