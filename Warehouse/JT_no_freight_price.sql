
--CREATE PROC JT_no_freight_price AS

/* -----------------------------------------------------*
** James Tuttle					Created: 9/23/2009		*
** Modifed to SQL: 07/13/2011							*
** -----------------------------------------------------*
** 	 Look for Ship VIA Codes and verify there is a		*
**   FREIGHT Item Line on it by Customer				*
**   or a Cost Greater than 0.000						*
**------------------------------------------------------*
*/
-- 1/14/10 - James Tuttle::: Added != to "FN" in the Viac
-- Field, Freight No Charge per Colleen B --


select  olico as Company,
	oliloc as Location,
	olord# as [Order],
	olrel# as Release,
	ohvia as Via,
	olitem as Item,
	olpric as Price,
	olcost as Cost	
FROM OPENQUERY (GSFL2K, 'SELECT *
	FROM ooline INNER JOIN oohead ON olco=ohco
		AND olloc=olloc
		AND olord#=ohord#
		AND olrel#=ohrel#
	WHERE olitem = ''FREIGHT''
		AND olinvu = ''T''
		AND olcost < 0
		AND olotyp NOT IN(''FO'', ''SA'')
		AND ohvia NOT LIKE ''%FN%''
		AND olinvu = ''T''
	')


