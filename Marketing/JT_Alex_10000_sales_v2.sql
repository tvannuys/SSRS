
--=================================================================================================================
-- SR-4059
-- James Tuttle		10/12/2012
-- Added CustName after Cust#
-- Created User friendly field names
--=================================================================================================================

ALTER PROC JT_Alex_5000 AS
SET NOCOUNT ON
BEGIN

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
		,cmname varchar(25)		-- Customer Name
		,shodat date			-- Order date
		,shsdat date			-- Ship date
		,slitem varchar(30)		-- Item
		,sldesc varchar(40)		-- Item description
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
		SELECT slco as co
				,slloc as loc
				,slord# as order# 
				,slcust as cust#
				,cmname as cust_name
				,shodat as date_created
				,shsdat as date_shipped
				,slitem as item
				,sldesc as description
				,slpric as price
				,slblus as billable_units
				,slum2 as um
				,shquot as quote#
				,sleprc as sub_total
				,shstnm as shipto
				,shsta1 as address1
				,shsta2 as address2
				,shsta3 as city_state
				,shzip as zip
		FROM shline
		LEFT JOIN shhead ON (shhead.shco = shline.slco
								AND shhead.shloc = shline.slloc
								AND shhead.shord# = shline.slord#
								AND shhead.shrel# = shline.slrel#
								AND shhead.shinv# = shline.slinv#
								AND shhead.shcust = shline.slcust)
		LEFT JOIN custmast on cmcust = slcust
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
		,cmname varchar(25)		-- Customer Name
		,ohodat date			-- Order date
		,ohsdat date			-- Ship date
		,olitem varchar(30)		-- Item
		,oldesc varchar(40)		-- Item Description
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
		SELECT olco as co
				,olloc as loc
				,olord# as order# 
				,olcust as cust#
				,cmname as cust_name
				,ohodat as date_created
				,ohsdat as date_shipped
				,olitem as item
				,oldesc as description
				,olpric as price
				,olblus as billable_units
				,olum2 as um
				,ohquot as quote#
				,oleprc as sub_total
				,ohstnm as shipto
				,ohsta1 as address1
				,ohsta2 as address2
				,ohsta3 as city_state
				,ohzip as zip
		FROM ooline
		LEFT JOIN oohead ON (oohead.ohco = ooline.olco
								AND oohead.ohloc = ooline.olloc
								AND oohead.ohord# = ooline.olord#
								AND oohead.ohrel# = ooline.olrel#
							/*	AND oohead.ohinv# = ooline.olinv#	*/
								AND oohead.ohcust = ooline.olcust)
		LEFT JOIN custmast on cmcust = olcust
		WHERE oohead.ohord# in (select OrderNum from OO)
			AND oohead.ohodat >= ''01/01/2011'' 
		ORDER BY olord#                                    
	')
-------------------------------------------------------------------------------------------------------------------
-- Union temp tables together for one data set and labeled into laymen terms
-------------------------------------------------------------------------------------------------------------------
--SELECT * FROM #BO
--UNION ALL
--SELECT * FROM #OO 

	SELECT	slco as co
			,slloc as loc
			,slord# as order# 
			,slcust as cust#
			,cmname as cust_name
			,shodat as date_created
			,shsdat as date_shipped
			,slitem as item
			,sldesc AS [description]
			,slpric as price
			,slblus as billable_units
			,slum2 as um
			,shquot as quote#
			,sleprc as sub_total
			,shstnm as shipto
			,shsta1 as address1
			,shsta2 as address2
			,shsta3 as city_state
			,shzip as zip
	FROM #BO
	UNION ALL
	SELECT	olco as co
			,olloc as loc
			,olord# as order# 
			,olcust as cust#
			,cmname as cust_name
			,ohodat as date_created
			,ohsdat as date_shipped
			,olitem as item
			,oldesc AS [description]
			,olpric as price
			,olblus as billable_units
			,olum2 as um
			,ohquot as quote#
			,oleprc as sub_total
			,ohstnm as shipto
			,ohsta1 as address1
			,ohsta2 as address2
			,ohsta3 as city_state
			,ohzip as zip
	FROM #OO
SET NOCOUNT OFF
END

-- JT_Alex_5000