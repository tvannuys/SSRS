/*********************************************************************************
**																				**
** SR# 11952																	**
** Programmer: James Tuttle		Date: 06/21/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:			Key in a route and see if any orders are on Credit Hold		**
**					and what the weights are.									**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_Route_CreditHold 
	@Route nvarchar(5)
AS
BEGIN
SET @Route = UPPER(@Route)
DECLARE @sql varchar(3000) = '
 SELECT *
 FROM OPENQUERY(GSFL2K,	
	''SELECT ohco
			,ohloc
			,ohord#
			,ohrel#
			,olitem
			,(imwght * olqord) AS Wgt

	FROM oohead oh
	LEFT JOIN ooline ol ON (ol.olco = oh.ohco
						AND ol.olloc = oh.ohloc
						AND ol.olord# = oh.ohord#
						AND ol.olrel# = oh.ohrel#
						AND ol.olcust =oh.ohcust)
	LEFT JOIN itemmast im ON im.imitem = ol.olitem
	
	WHERE ohrout = ' + '''' + '''' + @Route + '''' + '''' + '
		AND oh.ohcrhl = ''''Y''''
	'')
	'
END
EXEC(@sql)

--  JT_Route_CreditHold 'TEST'