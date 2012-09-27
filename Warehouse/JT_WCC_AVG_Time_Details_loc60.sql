

-- James Tuttle
-- 05/15/2012
-- WCC Details for the average Time
--

CREATE PROC [dbo].[JT_WCC_AVG_Time_Details_loc60] AS

SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfcust
							 	,rfoord#
								,rforel#	
								,rfotime
								,rptime
							FROM rfwillchst
							WHERE rfloc IN (60, 41, 59)
								AND rfodate = CURRENT_DATE 
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							--	AND rfoord# = 34804
					')
ORDER BY rfcust
		,rfotime
GO


