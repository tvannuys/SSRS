


/* -------------------------------------------------*	 
*	James Tuttle									*
*	10/13/2011										*
* ================================================= *
*													*
* look at open orders for a route LIKE aaaaX		*
*---------------------------------------------------*/												
													
ALTER PROC JT_route_with_x AS

BEGIN
	SELECT *
	FROM OPENQUERY (GSFL2K, 'SELECT ohco
							,ohloc
							,ohotyp
							,ohord#
							,ohrel#
							,ohrout
							
						FROM oohead oh
						JOIN ooline ol ON ( ol.olco = oh.ohco
											AND ol.olloc = oh.ohloc
											AND ol.olord# = oh.ohord#
											AND ol.olrel# = oh.ohrel#
											AND ol.olcust = oh.ohcust)
						WHERE ohrout LIKE ''%X%''
							AND ol.olINVU != ''T''
						
						GROUP BY oh.ohco
								,oh.ohloc
								,oh.ohotyp
								,oh.ohord#
								,oh.ohrel#
								,oh.ohrout
						ORDER BY oh.ohotyp DESC
				')
END
			