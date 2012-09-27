

-- SR-4059

-------------> ADD THE REQUIRED FIELDS THAT IS NEEDED FOR THE DATA MINNING <----------------

-------------------------------------------------------------------------------------------------------------------
-- INVOICED ORDERS
-------------------------------------------------------------------------------------------------------------------
-- Create Billed Orders TEMP Table - drop if exists
IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#BO'))
BEGIN
	DROP TABLE #BO
END
							-----------------------------------------------
							-- FIELDS NAMES FROM THE TABLES IN GARTMAN	---
CREATE TABLE #BO (			-----------------------------------------------
	slco int				-- Compnay
	,slloc int				-- Location
	,slord# int				-- Order#
	,slcust varchar(15)		-- Customer#
	,shodat date			-- Order date
	,shsdat date			-- Ship date
	,slitem varchar(30)		-- Item
	,slpric float			-- Unit price
	,slblus float			-- Billable units ship
	,slum2 varchar(5)		-- Billable units of measure
	,shquot int				-- Quote#
	,sleprc float			-- Sub total
	,shstnm varchar(25)		-- Ship to name
	,shsta1 varchar(25)		-- Ship to address 1
	,shsta2 varchar(25)		-- Ship to address 2
	,shsta3 varchar(25)		-- Ship to address 3
	,shzip varchar(9)		-- Ship to zip
)							-----------------------------------------------

INSERT #BO
SELECT * FROM OPENQUERY(GSFL2K,'
	WITH BO AS (SELECT h.shco as Company
				,h.shloc as Location
				,h.shord# as OrderNum
				,h.shcust as Cust
				,sum(h.shtotl) as OrderTotal
			FROM shhead h
			WHERE h.shidat >= ''01/01/2011''
			GROUP BY h.shco
					,h.shloc
					,h.shord#
					,h.shcust
			HAVING SUM(h.shtotl) >= 5000)            
	SELECT slco a
			,slloc
			,slord# 
			,slcust
			,shodat
			,shsdat
			,slitem
			,slpric
			,slblus
			,slum2
			,shquot
			,sleprc
			,shstnm
			,shsta1
			,shsta2
			,shsta3
			,shzip
	FROM shline
	LEFT JOIN shhead ON (shhead.shco = shline.slco
							AND shhead.shloc = shline.slloc
							AND shhead.shord# = shline.slord#
							AND shhead.shrel# = shline.slrel#
							AND shhead.shinv# = shline.slinv#
							AND shhead.shcust = shline.slcust)
	WHERE shhead.shord# in (select OrderNum from BO)
		AND shhead.shidat >= ''01/01/2011'' 
	ORDER BY slord#                                      
')
 
-------------------------------------------------------------------------------------------------------------------------------
-- OPEN ORDERS
-------------------------------------------------------------------------------------------------------------------------------
-- Create Open Orders TEMP Table - drop if exists
IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#OO'))
BEGIN
	DROP TABLE #OO
END
							-----------------------------------------------
							-- FIELDS NAMES FROM THE TABLES IN GARTMAN	---
CREATE TABLE #OO (			-----------------------------------------------
	olco int				-- Compnay
	,olloc int				-- Location
	,olord# int				-- Order#
	,olcust varchar(15)		-- Customer#
	,ohodat date			-- Order date
	,ohsdat date			-- Ship date
	,olitem varchar(30)		-- Item
	,olpric float			-- Unit price
	,olblus float			-- Billable units ship
	,olum2 varchar(5)		-- Billable units of measure
	,ohquot int				-- Quote#
	,oleprc float			-- Sub total
	,ohstnm varchar(25)		-- Ship to name
	,ohsta1 varchar(25)		-- Ship to address 1
	,ohsta2 varchar(25)		-- Ship to address 2
	,ohsta3 varchar(25)		-- Ship to address 3
	,ohzip varchar(9)		-- Ship to zip
)							-----------------------------------------------

INSERT #OO
SELECT * FROM OPENQUERY(GSFL2K,'
	WITH OO AS (SELECT h.ohco as Company
				,h.ohloc as Location
				,h.ohord# as OrderNum
				,h.ohcust as Cust
				,sum(h.ohtotl) as OrderTotal
			FROM oohead h
			WHERE h.ohodat >= ''01/01/2011''
			GROUP BY h.ohco
					,h.ohloc
					,h.ohord#
					,h.ohcust
			HAVING SUM(h.ohtotl) >= 5000)            
	SELECT olco a
			,olloc
			,olord# 
			,olcust
			,ohodat
			,ohsdat
			,olitem
			,olpric
			,olblus
			,olum2
			,ohquot
			,oleprc
			,ohstnm
			,ohsta1
			,ohsta2
			,ohsta3
			,ohzip
	FROM ooline
	LEFT JOIN oohead ON (oohead.ohco = ooline.olco
							AND oohead.ohloc = ooline.olloc
							AND oohead.ohord# = ooline.olord#
							AND oohead.ohrel# = ooline.olrel#
						/*	AND oohead.ohinv# = ooline.olinv#	*/
							AND oohead.ohcust = ooline.olcust)
	WHERE oohead.ohord# in (select OrderNum from OO)
		AND oohead.ohodat >= ''01/01/2011'' 
	ORDER BY olord#                                    
')
-------------------------------------------------------------------------------------------------------------------
-- Union temp tables together for one data set
-------------------------------------------------------------------------------------------------------------------
SELECT * FROM #BO
UNION ALL
SELECT * FROM #OO 
