-- James Tuttle
-- 05/15/2012
-- WCC Details for the average Time
--

--CREATE PROC JT_WCC_AVG_Time_Details_loc50 AS

SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfcust
							 	,rfoord#
								,rforel#	
								,rfotime
								,rptime
							FROM rfwillchst
							WHERE rfloc = 50
								AND rfodate = CURRENT_DATE 
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							--	AND rfoord# = 34804
					')
ORDER BY rfcust
		,rfotime