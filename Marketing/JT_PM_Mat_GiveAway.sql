
/*********************************************************************************
**																				**
** SR# 7881																		**
** Programmer: James Tuttle		Date: 02/14/2013								**
** ---------------------------------------------------------------------------- **
** Purpose:		For Pacmat's Promotion "Mat Give-A-Way"							**
**				A report for Mary H that gives her the prior week's				**
**				Orders if the Qty was a full pallet.							**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_PM_Mat_GiveAway
	-- @StartDate varchar(10)
	--,@EndDate varchar(10)
	 AS

SET NOCOUNT ON18
BEGIN

---- Last Saturday's date
--	SET @StartDate = CONVERT(varchar(10), DATEADD(dd, -7, DATEDIFF(dd, 0, GETDATE())), 101)	
---- Today's date [Friday]
--	SET @EndDate = CONVERT(varchar(10), DATEADD(dd, -1, DATEDIFF(dd, 0, GETDATE())), 101)	
	
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
		
		WHERE sh.shodat >= ''02/18/2013'' /* CURRENT_DATE -7 DAYS */
			AND sh.shodat <= ''02/24/2013'' /*CURRENT_DATE -1 DAYS */
			AND ((sl.slitem = ''GR030BP4503'' AND sl.slpric >= 1.79) OR (sl.slitem = ''GR031BP4503'' AND sl.slpric >= 1.79)
				OR (sl.slitem = ''GR104BP4503'' AND sl.slpric >= 1.79) OR (sl.slitem = ''GR105BP4503'' AND sl.slpric >= 1.79)
				OR (sl.slitem = ''GR106BP4503'' AND sl.slpric >= 1.79) OR (sl.slitem = ''GR107BP4503'' AND sl.slpric >= 1.79)
				OR (sl.slitem = ''GR004HS5005'' AND sl.slpric >= 2.09) OR (sl.slitem = ''GR020HS5005'' AND sl.slpric >= 2.09)
				OR (sl.slitem = ''EWLWC4810'' AND sl.slpric >= 2.69) OR (sl.slitem = ''EWLWC4811'' AND sl.slpric >= 2.69)
				OR (sl.slitem = ''EWLWC4812'' AND sl.slpric >= 2.69) OR (sl.slitem = ''EWLWC4813'' AND sl.slpric >= 2.69)
				OR (sl.slitem = ''EWLWC4814'' AND sl.slpric >= 2.69) OR (sl.slitem = ''EWLWC4815'' AND sl.slpric >= 2.69)
				OR (sl.slitem = ''EWLWC4816'' AND sl.slpric >= 2.69) OR (sl.slitem = ''EWLWC4817'' AND sl.slpric >= 2.69)
				OR (sl.slitem = ''EWLWC4818'' AND sl.slpric >= 2.69) OR (sl.slitem = ''EWLWC4819'' AND sl.slpric >= 2.69)
				OR (sl.slitem = ''EWLWA3629'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA1251'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''EWLWA1252'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA1253'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''EWLWA1254'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA3620'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''EWLWA3621'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA3622'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''EWLWA3623'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA3624'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''EWLWA3625'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA3626'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''EWLWA3627'' AND sl.slpric >= 2.29) OR (sl.slitem = ''EWLWA3628'' AND sl.slpric >= 2.29)
				OR (sl.slitem = ''LOGVTL21112P'' AND sl.slpric >= 1.51) OR (sl.slitem = ''LOGVTL30312P'' AND sl.slpric >= 1.51)
				OR (sl.slitem = ''LOGVTL40112P'' AND sl.slpric >= 1.51) OR (sl.slitem = ''LOGVTL50512P'' AND sl.slpric >= 1.51)
				OR (sl.slitem = ''LOGVTL67912P'' AND sl.slpric >= 1.51) OR (sl.slitem = ''LOGVTL10312P'' AND sl.slpric >= 1.51)
				OR (sl.slitem = ''GR1020961B'' AND sl.slpric >= 1.36) OR (sl.slitem = ''GR10209611B'' AND sl.slpric >= 1.36)
				OR (sl.slitem = ''GR1020963B'' AND sl.slpric >= 1.36) OR (sl.slitem = ''GAGVTT10910P'' AND sl.slpric >= 1.31)
				OR (sl.slitem = ''GAGVTT21610P'' AND sl.slpric >= 1.31) OR (sl.slitem = ''GAGVTT32410P'' AND sl.slpric >= 1.31)
				OR (sl.slitem = ''GAGVTT40210P'' AND sl.slpric >= 1.31) OR (sl.slitem = ''GAGVTT53110P'' AND sl.slpric >= 1.31)
				OR (sl.slitem = ''GR820961B'' AND sl.slpric >= 1.19) OR (sl.slitem = ''GR820963B'' AND sl.slpric >= 1.19)
				OR (sl.slitem = ''LOGVWC10208P'' AND sl.slpric >= 1.08) OR (sl.slitem = ''LOGVWC20208P'' AND sl.slpric >= 1.08)
				OR (sl.slitem = ''LOGVWC20508P'' AND sl.slpric >= 1.08) OR (sl.slitem = ''LOGVWC21408P'' AND sl.slpric >= 1.08)
				OR (sl.slitem = ''LOGVWC30108P'' AND sl.slpric >= 1.08) OR (sl.slitem = ''LOGVWC40208P'' AND sl.slpric >= 1.08)
				OR (sl.slitem = ''LOGVWC50208P'' AND sl.slpric >= 1.08) OR (sl.slitem = ''LOGVWC60208P'' AND sl.slpric >= 1.08)
				OR (sl.slitem = ''LOGVWC61208P'' AND sl.slpric >= 1.08) OR (sl.slitem = ''LOGVWC70208P'' AND sl.slpric >= 1.08)		
			)
			AND imf.ifumc = ''1''
			AND imf.iffaca <= sl.slqshp
	') 
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
								
		WHERE oh.ohodat >=  ''02/18/2013'' /*CURRENT_DATE -7 DAYS   */
			AND oh.ohodat <=  ''02/24/2013'' /*CURRENT_DATE -1 DAYS */
			AND ((ol.olitem  = ''GR030BP4503'' AND ol.olpric >= 1.79) OR (ol.olitem  = ''GR031BP4503'' AND ol.olpric >= 1.79)
				OR (ol.olitem  = ''GR104BP4503'' AND ol.olpric >= 1.79) OR (ol.olitem  = ''GR105BP4503'' AND ol.olpric >= 1.79)
				OR (ol.olitem  = ''GR106BP4503'' AND ol.olpric >= 1.79) OR (ol.olitem  = ''GR107BP4503'' AND ol.olpric >= 1.79)
				OR (ol.olitem  = ''GR004HS5005'' AND ol.olpric >= 2.09) OR (ol.olitem  = ''GR020HS5005'' AND ol.olpric >= 2.09)
				OR (ol.olitem  = ''EWLWC4810'' AND ol.olpric >= 2.69) OR (ol.olitem  = ''EWLWC4811'' AND ol.olpric >= 2.69)
				OR (ol.olitem  = ''EWLWC4812'' AND ol.olpric >= 2.69) OR (ol.olitem  = ''EWLWC4813'' AND ol.olpric >= 2.69)
				OR (ol.olitem  = ''EWLWC4814'' AND ol.olpric >= 2.69) OR (ol.olitem  = ''EWLWC4815'' AND ol.olpric >= 2.69)
				OR (ol.olitem  = ''EWLWC4816'' AND ol.olpric >= 2.69) OR (ol.olitem  = ''EWLWC4817'' AND ol.olpric >= 2.69)
				OR (ol.olitem  = ''EWLWC4818'' AND ol.olpric >= 2.69) OR (ol.olitem  = ''EWLWC4819'' AND ol.olpric >= 2.69)
				OR (ol.olitem  = ''EWLWA3629'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA1251'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''EWLWA1252'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA1253'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''EWLWA1254'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA3620'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''EWLWA3621'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA3622'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''EWLWA3623'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA3624'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''EWLWA3625'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA3626'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''EWLWA3627'' AND ol.olpric >= 2.29) OR (ol.olitem  = ''EWLWA3628'' AND ol.olpric >= 2.29)
				OR (ol.olitem  = ''LOGVTL21112P'' AND ol.olpric >= 1.51) OR (ol.olitem  = ''LOGVTL30312P'' AND ol.olpric >= 1.51)
				OR (ol.olitem  = ''LOGVTL40112P'' AND ol.olpric >= 1.51) OR (ol.olitem  = ''LOGVTL50512P'' AND ol.olpric >= 1.51)
				OR (ol.olitem  = ''LOGVTL67912P'' AND ol.olpric >= 1.51) OR (ol.olitem  = ''LOGVTL10312P'' AND ol.olpric >= 1.51)
				OR (ol.olitem  = ''GR1020961B'' AND ol.olpric >= 1.36) OR (ol.olitem  = ''GR10209611B'' AND ol.olpric >= 1.36)
				OR (ol.olitem  = ''GR1020963B'' AND ol.olpric >= 1.36) OR (ol.olitem  = ''GAGVTT10910P'' AND ol.olpric >= 1.31)
				OR (ol.olitem  = ''GAGVTT21610P'' AND ol.olpric >= 1.31) OR (ol.olitem  = ''GAGVTT32410P'' AND ol.olpric >= 1.31)
				OR (ol.olitem  = ''GAGVTT40210P'' AND ol.olpric >= 1.31) OR (ol.olitem  = ''GAGVTT53110P'' AND ol.olpric >= 1.31)
				OR (ol.olitem  = ''GR820961B'' AND ol.olpric >= 1.19) OR (ol.olitem  = ''GR820963B'' AND ol.olpric >= 1.19)
				OR (ol.olitem  = ''LOGVWC10208P'' AND ol.olpric >= 1.08) OR (ol.olitem  = ''LOGVWC20208P'' AND ol.olpric >= 1.08)
				OR (ol.olitem  = ''LOGVWC20508P'' AND ol.olpric >= 1.08) OR (ol.olitem  = ''LOGVWC21408P'' AND ol.olpric >= 1.08)
				OR (ol.olitem  = ''LOGVWC30108P'' AND ol.olpric >= 1.08) OR (ol.olitem  = ''LOGVWC40208P'' AND ol.olpric >= 1.08)
				OR (ol.olitem  = ''LOGVWC50208P'' AND ol.olpric >= 1.08) OR (ol.olitem  = ''LOGVWC60208P'' AND ol.olpric >= 1.08)
				OR (ol.olitem  = ''LOGVWC61208P'' AND ol.olpric >= 1.08) OR (ol.olitem  = ''LOGVWC70208P'' AND ol.olpric >= 1.08)		
			)
			AND imf.ifumc = ''1''
			AND imf.iffaca <= ol.olqshp
	') 
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



-- JT_PM_Mat_GiveAway '02/04/2013', '02/24/2013'


/* 
IN (''GR030BP4503'',''GR031BP4503'',''GR104BP4503'',''GR105BP4503'',''GR106BP4503'',''GR107BP4503''
				,''GR004HS5005'',''GR020HS5005'',''EWLWC4810'',''EWLWC4811'',''EWLWC4812'',''EWLWC4813'',''EWLWC4814'',''EWLWC4815''
				,''EWLWC4816'',''EWLWC4817'',''EWLWC4818'',''EWLWC4819'',''EWLWA3629'',''EWLWA1251'',''EWLWA1252'',''EWLWA1253''
				,''EWLWA1254'',''EWLWA3620'',''EWLWA3621'',''EWLWA3622'',''EWLWA3623'',''EWLWA3624'',''EWLWA3625'',''EWLWA3626''
				,''EWLWA3627'',''EWLWA3628'',''LOGVTL21112P'',''LOGVTL30312P'',''LOGVTL40112P'',''LOGVTL50512P'',''LOGVTL67912P''
				,''LOGVTL10312P'',''GR1020961B'',''GR10209611B'',''GR1020963B'',''GAGVTT10910P'',''GAGVTT21610P'',''GAGVTT32410P''
				,''GAGVTT40210P'',''GAGVTT53110P'',''GR820961B'',''GR820963B'',''LOGVWC10208P'',''LOGVWC20208P'',''LOGVWC20508P''
				,''LOGVWC21408P'',''LOGVWC30108P'',''LOGVWC40208P'',''LOGVWC50208P'',''LOGVWC60208P'',''LOGVWC61208P'',''LOGVWC70208P'')
*/