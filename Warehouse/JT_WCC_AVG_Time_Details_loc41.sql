-- James Tuttle
-- 05/15/2012
-- WCC Details for the average Time
--

--CREATE PROC JT_WCC_AVG_Time_Details_loc41 AS

SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfcust
							 	,rfoord#
								,rforel#	
								,rfotime
								,rptime
							FROM rfwillchst
							WHERE rfloc = 41
								AND rfodate = CURRENT_DATE - 1 DAYS
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
				
					')
ORDER BY rfcust
		,rfotime