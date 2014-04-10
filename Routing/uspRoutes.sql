
CREATE PROC uspRoutes AS

SELECT * FROM OPENQUERY(GSFL2K,'SELECT rtco AS Co
										,rtloc AS Loc
										,rtrout AS Route
										,RTDESC AS Desc	
							
						FROM route

						ORDER BY rtco
						' )
