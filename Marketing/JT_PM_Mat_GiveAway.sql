
/*********************************************************************************
**																				**
** SR# 7881																		**
** Programmer: James Tuttle		Date: 02/14/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:		For Pacmat's Promotion " Mat Give-A-Way"						**
**				A report for Mary H that gives her the prior week's				**
**				Orders if the Qty was a full pallet.							**
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
								-- FIELD NAMES FROM THE TABLES IN GARTMAN	---
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
		,slqshp INT				-- Qty shipped
		,slum1	varchar(5)		-- Unit of measure
		,iffaca INT				-- Full pallet qty
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
				,slqshp
				,slum1
				,iffaca 
				
		FROM shline sl
		LEFT JOIN shhead sh ON (sh.shco = sl.slco
								AND sh.shloc = sl.slloc
								AND sh.shord# = sl.slord#
								AND sh.shrel# = sl.slrel#
								AND sh.shinv# = sl.slinv#
								AND sh.shcust = sl.slcust)
		LEFT JOIN custmast on cmcust = slcust
		LEFT JOIN itemfact imf ON imf.ifitem = sl.slitem

		WHERE sh.shodat BETWEEN ''2/4/2013'' AND ''2/8/2013''
			
			AND sl.slitem IN (''GR030BP4503'',''GR031BP4503'',''GR104BP4503'',''GR105BP4503'',''GR106BP4503'',''GR107BP4503''
				,''GR004HS5005'',''GR020HS5005'',''EWLWC4810'',''EWLWC4811'',''EWLWC4812'',''EWLWC4813'',''EWLWC4814'',''EWLWC4815''
				,''EWLWC4816'',''EWLWC4817'',''EWLWC4818'',''EWLWC4819'',''EWLWA3629'',''EWLWA1251'',''EWLWA1252'',''EWLWA1253''
				,''EWLWA1254'',''EWLWA3620'',''EWLWA3621'',''EWLWA3622'',''EWLWA3623'',''EWLWA3624'',''EWLWA3625'',''EWLWA3626''
				,''EWLWA3627'',''EWLWA3628'',''LOGVTL21112P'',''LOGVTL30312P'',''LOGVTL40112P'',''LOGVTL50512P'',''LOGVTL67912P''
				,''LOGVTL10312P'',''GR1020961B'',''GR10209611B'',''GR1020963B'',''GAGVTT10910P'',''GAGVTT21610P'',''GAGVTT32410P''
				,''GAGVTT40210P'',''GAGVTT53110P'',''GR820961B'',''GR820963B'',''LOGVWC10208P'',''LOGVWC20208P'',''LOGVWC20508P''
				,''LOGVWC21408P'',''LOGVWC30108P'',''LOGVWC40208P'',''LOGVWC50208P'',''LOGVWC60208P'',''LOGVWC61208P'',''LOGVWC70208P'')

			AND imf.ifumc = ''1''
			AND imf.iffaca <= sl.slqshp
	')
	--''''' + @StartDate  + ''''' AND ''''' + @EndDate + ''''' 
	/*AND sl.slprcd IN (13430, 13431, 32604, 32602, 32600, 13635 , 13420, 13619, 13411, 13621) Going by Item */
--=================================================================================================================
-- OPEN ORDERS
--=================================================================================================================
-- Create Open Orders TEMP Table - drop if exists
	IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#OO'))
	BEGIN
		DROP TABLE #OO
	END
								--=============================================
								-- FIELD NAMES FROM THE TABLES IN GARTMAN	---
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
		,oleprc FLOAT			-- Sub total
		,olqshp	INT				-- Qty shipped
		,olum1 varchar(5)		-- Unit of measure
		,iffaca INT				-- Full pallet qty
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
				,olqshp
				,olum1
				,iffaca 
				
		FROM ooline ol
		LEFT JOIN oohead oh ON (oh.ohco = ol.olco
								AND oh.ohloc = ol.olloc
								AND oh.ohord# = ol.olord#
								AND oh.ohrel# = ol.olrel#
								AND oh.ohcust = OL.olcust)
		LEFT JOIN custmast cm on cm.cmcust = ol.olcust
		LEFT JOIN itemfact imf ON imf.ifitem = ol.olitem
								
		WHERE oh.ohodat BETWEEN ''2/4/2013'' AND ''2/8/2013''
			
			AND ol.olitem IN (''GR030BP4503'',''GR031BP4503'',''GR104BP4503'',''GR105BP4503'',''GR106BP4503'',''GR107BP4503''
				,''GR004HS5005'',''GR020HS5005'',''EWLWC4810'',''EWLWC4811'',''EWLWC4812'',''EWLWC4813'',''EWLWC4814'',''EWLWC4815''
				,''EWLWC4816'',''EWLWC4817'',''EWLWC4818'',''EWLWC4819'',''EWLWA3629'',''EWLWA1251'',''EWLWA1252'',''EWLWA1253''
				,''EWLWA1254'',''EWLWA3620'',''EWLWA3621'',''EWLWA3622'',''EWLWA3623'',''EWLWA3624'',''EWLWA3625'',''EWLWA3626''
				,''EWLWA3627'',''EWLWA3628'',''LOGVTL21112P'',''LOGVTL30312P'',''LOGVTL40112P'',''LOGVTL50512P'',''LOGVTL67912P''
				,''LOGVTL10312P'',''GR1020961B'',''GR10209611B'',''GR1020963B'',''GAGVTT10910P'',''GAGVTT21610P'',''GAGVTT32410P''
				,''GAGVTT40210P'',''GAGVTT53110P'',''GR820961B'',''GR820963B'',''LOGVWC10208P'',''LOGVWC20208P'',''LOGVWC20508P''
				,''LOGVWC21408P'',''LOGVWC30108P'',''LOGVWC40208P'',''LOGVWC50208P'',''LOGVWC60208P'',''LOGVWC61208P'',''LOGVWC70208P'')

			AND imf.ifumc = ''1''
			AND imf.iffaca <= ol.olqshp
	')
	--''''' + @StartDate  + ''''' AND ''''' + @EndDate + ''''' 
	/* AND ol.olprcd IN (13430, 13431, 32604, 32602, 32600, 13635 , 13420, 13619, 13411, 13621)Going by Item */
--=================================================================================================================
-- Union TEMP Tables together for one data set and labeled into laymen terms
--=================================================================================================================
	SELECT	slco	as co
			,slloc	as loc
			,slord# as order# 
			,slcust as cust#
			,cmname as cust_name
			,shodat as date_created
			,shsdat as date_shipped
			,slitem as item
			,sldesc AS [description]
			,slpric as price
			,slblus as billable_units
			,slum2	as um
			,sleprc AS ext_price
			,slqshp AS Qty_Shp
			,slum1	AS	U_M
			,iffaca AS Plt_Qty
	FROM #SH
	UNION ALL
	SELECT	olco	as co
			,olloc	as loc
			,olord# as order# 
			,olcust as cust#
			,cmname as cust_name
			,ohodat as date_created
			,ohsdat as date_shipped
			,olitem as item
			,oldesc AS [description]
			,olpric as price
			,olblus as billable_units
			,olum2	as um
			,oleprc AS ext_price
			,olqshp AS Qty_Shp
			,olum1	AS U_M
			,iffaca AS Plt_Qty
	FROM #OO
SET NOCOUNT OFF



END