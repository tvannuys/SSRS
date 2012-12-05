-------------------------------------------------------------
-- SR# 5924
-- James Tuttle
-- 12/5/2012
-- Query to count distinct customers that had orders
--    shipped the day of the report
-------------------------------------------------------------
CREATE PROC JT_WCC_Cust_CNT_loc12 AS
BEGIN
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT COUNT(DISTINCT rfcust) AS Cust_Cnt
							FROM rfwillchst
							WHERE rfloc IN (12, 22, 69)
								AND rfodate = CURRENT_DATE
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''				
					')
/*-------------------------------------------------------------
	-- DETAILS
	SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT *
							FROM rfwillchst
							WHERE rfloc IN (12, 22, 69)
								AND rfodate = CURRENT_DATE
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''				
					')
-------------------------------------------------------------*/
END