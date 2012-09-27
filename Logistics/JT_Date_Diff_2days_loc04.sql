-------------------------------------------------------
-- James Tuttle
-- 07/06/2012
-------------------------------------------------------
--
-- Spokane Route looking at the first
-- leg of the route ship date and then
-- the second leg of the route's ship date 
-- and if greater than two days email the 
-- report to Mary N.
-------------------------------------------------------
-- Gather data from AS400 
-- and put into a CTE
CREATE PROC JT_date_diff_2day_loc04 AS
BEGIN
	WITH CTE AS
	(
	 SELECT *
	 FROM OPENQUERY(GSFL2K,
		'SELECT ortord
				,ortrel
				,ortsdt
				,ortadt
		FROM ooroute
		JOIN oohead 
			ON (ortco = ohco
				AND ortloc = ohloc
				AND ortord = ohord#
				AND ortrel = ohrel#
				AND ortcus = ohcust)
		WHERE ohrout = ''50-04''
			AND ohsdat = CURRENT_DATE
		 ')
	)
	-------------------------------------------------------
	-- Take AS400 data and 
	-- use the CTE as an Inner Self Join
	-- to compare the ship dates of the
	-- two rows of the routing
	-------------------------------------------------------
	SELECT rt1.ortord AS [Order]
			,rt1.ortrel AS [Rel#]
			,rt1.ortsdt AS [Ship Date 1]
			,rt2.ortsdt AS [Ship Date 2]
	FROM CTE as rt1
	JOIN CTE AS rt2
		ON rt1.ortord = rt2.ortord	
		AND DATEDIFF(dd, rt1.ortsdt, rt2.ortsdt) >= 3
	-------------------------------------------------------
END
GO
