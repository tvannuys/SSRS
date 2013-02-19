
/*********************************************************************************
**																				**
** SR# 7881																		**
** Programmer: James Tuttle		Date: 02/14/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:																		**
**																				**
**																				**
**																				**
**																				**
**																				**
**********************************************************************************/

------------CREATE PROC JT_PM_Mat_GiveAway @StartDate varchar(10)
------------	,@EndDate varchar(10)
------------	 AS
------------DECLARE @sql
------------SET @sql = 
------------SET NOCOUNT ON
BEGIN
--=================================================================================================================
-- INVOICED ORDERS
--=================================================================================================================
-- Create Billed Orders TEMP Table - drop if exists
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#SH'))
	BEGIN
		DROP TABLE #SH
	END
								--=============================================
								-- FIELDS NAMES FROM THE TABLES IN GARTMAN	---
	CREATE TABLE #SH (			--=============================================
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
		,sleprc float			-- Sub total
	)							--=============================================

	INSERT #SH
	SELECT * FROM OPENQUERY(GSFL2K,'
		SELECT slco
				,slloc
				,slord#
				,slcust
				,cmname
				,shodat
				,shsdat
				,slitem
				,sldesc
				,slpric
				,slblus
				,slum2
				,sleprc
		FROM shline
		LEFT JOIN shhead ON (shhead.shco = shline.slco
								AND shhead.shloc = shline.slloc
								AND shhead.shord# = shline.slord#
								AND shhead.shrel# = shline.slrel#
								AND shhead.shinv# = shline.slinv#
								AND shhead.shcust = shline.slcust)
		LEFT JOIN custmast on cmcust = slcust
		WHERE shhead.shodat  = ''2/4/2013''
			AND shline.slprcd IN (13430, 13431, 32604, 32602, 32600, 13635 , 13420, 13619, 13411, 13621)
	')
	 --between ''''' + @StartDate  + ''''' AND ''''' + @EndDate + ''''' 
--=================================================================================================================
-- OPEN ORDERS
--=================================================================================================================
-- Create Open Orders TEMP Table - drop if exists
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#OO'))
	BEGIN
		DROP TABLE #OO
	END
								--=============================================
								-- FIELDS NAMES FROM THE TABLES IN GARTMAN	---
	CREATE TABLE #OO (			--=============================================
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
	)							--=============================================

	INSERT #OO
		SELECT * FROM OPENQUERY(GSFL2K,'
		SELECT olco
				,olloc
				,olord#
				,olcust
				,cmname
				,ohodat
				,ohsdat
				,olitem
				,oldesc
				,olpric
				,olblus
				,olum2
				,oleprc
		FROM ooline 
		LEFT JOIN oohead ON (oohead.ohco = ooline.olco
								AND oohead.ohloc = ooline.olloc
								AND oohead.ohord# = ooline.olord#
								AND ohhead.ohrel# = ooline.olrel#
								AND ohhead.ohinv# = ooline.olinv#
								AND ohhead.ohcust = ooline.olcust)
		LEFT JOIN custmast cm on cm.cmcust = ooline.olcust
		WHERE oohead.ohodat  = ''2/4/2013''
			AND ooline.olprcd IN (13430, 13431, 32604, 32602, 32600, 13635 , 13420, 13619, 13411, 13621)
	')
	--between ''''' + @StartDate  + ''''' AND ''''' + @EndDate + ''''' 
--=================================================================================================================
-- Union temp tables together for one data set and labeled into laymen terms
--=================================================================================================================
--SELECT * FROM #SH
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
	FROM #SH
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
	FROM #OO
SET NOCOUNT OFF



END