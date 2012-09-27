
--CREATE PROC JT_route_with_x AS

/* -------------------------------------------------*	 
*	James Tuttle									*
*	10/13/2011										*
* ================================================= *
*													*
* look at open orders for a route LIKE aaaaX		*
*---------------------------------------------------*/												
													



SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT ohco,
						ohloc,
						ohord#,
						ohrel#,
						ohrout
					FROM oohead
					WHERE ohrout LIKE ''%X%''
			')