


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
						FROM oohead
						WHERE ohrout LIKE ''%X%''
						ORDER BY ohotyp DESC
				')
END
			