USE [GartmanReport]
GO


-- James Tuttle
-- 05/15/2012
-- WCC Details for the average Time
--

ALTER PROC [dbo].[JT_WCC_User_Details_loc50] AS

SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT	rfouser
									,COUNT(rfoitem) AS LineCount	
								
							FROM rfwillchst
							
							WHERE rfloc = 50
								AND rfodate = CURRENT_DATE 
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							
							GROUP BY rfouser
								
					')

GO


