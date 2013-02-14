/*************************************************
**												**
** SR# 6397										**
** James Tuttle		Date: 12/20/2012			**
**												**
**     When time allows, could I please get a	**
**	report (01-01-2012 – current date) for ONLY **
**  FO order types, where we have billed		**
** “freight/Handlng” on the back, but only for  **
** those customers where AR terms payments are  **
** offered.										**
**												**
**************************************************/

--ALTER PROC JT_ReportTerms AS
 -----------------------------------------------------------------------------------------------------
 -- Sales History
 -----------------------------------------------------------------------------------------------------
BEGIN
	IF EXISTS (SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#SH')) 
	 BEGIN
		DROP TABLE #SH
	END

	CREATE TABLE #SH (
		shco int
		,shloc int
		,[MONTH] varchar(10) 
		,shinv# int
		,shcust VARCHAR(10)
		,cmname varchar(25)
		,shterm varchar(1)
		,tmdesc varchar(25)
		,shsam4 float
	)

	INSERT INTO #SH

	 SELECT *
	 FROM OPENQUERY(GSFL2K,
		'SELECT shco AS Co
			, shloc AS Loc
			, MONTH(shidat) || ''/'' || DAY(shidat) || ''/'' || YEAR(shidat) AS Inv_Date
			, shinv# AS Invoice#
			, shcust AS Cust#
			, cmname AS Cust_Name
			, shterm AS Term_Code
			, tmdesc AS Term_Desc
			, shsam4 AS Freight_Handling

		FROM shhead sh
		LEFT JOIN custmast cm ON 
			sh.shcust = cm.cmcust	
		LEFT JOIN arterms art ON
			art.tmterm = sh.shterm
			
		WHERE sh.shidat >= ''01/01/2012''
			AND sh.shotyp = ''FO''
			AND sh.shsam4 != 0
			AND art.tmdsc1 > .0000
		ORDER BY sh.shco
				,sh.shloc
				,sh.shidat
	 ')
	 
	 
	 
	 -----------------------------------------------------------------------------------------------------
	 -- Open Orders
	 -----------------------------------------------------------------------------------------------------
	 IF EXISTS (SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#OO')) 
	 BEGIN
		DROP TABLE #OO
	END

	CREATE TABLE #OO (
		ohco int
		,ohloc int
		,[MONTH] varchar(10) 
		,ohinv# int
		,ohcust VARCHAR(10)
		,cmname varchar(25)
		,ohterm varchar(1)
		,tmdesc varchar(25)
		,ohsam4 float
	)
	INSERT INTO #OO

	 SELECT *
	 FROM OPENQUERY(GSFL2K,
		'SELECT ohco AS Co
			, ohloc AS Loc
			, MONTH(ohodat) || ''/'' || DAY(ohodat) || ''/'' || YEAR(ohodat) AS Inv_Date
			, ohinv# AS Invoice#
			, ohcust AS Cust#
			, cmname AS Cust_Name
			, ohterm AS Term_Code
			, tmdesc AS Term_Desc
			, ohsam4 AS Freight_Handling

		FROM oohead oh
		LEFT JOIN custmast cm ON 
			oh.ohcust = cm.cmcust	
		LEFT JOIN arterms art ON
			art.tmterm = oh.ohterm
			
		WHERE oh.ohodat >= ''01/01/2012''
			AND oh.ohotyp = ''FO''
			AND oh.ohsam4 != 0
			AND art.tmdsc1 > .0000
		ORDER BY oh.ohco
				,oh.ohloc
				,oh.ohidat
	 ')
	 
	 ----------------------------------------------------------------------------------
	 -- UNION
	 ----------------------------------------------------------------------------------
	 SELECT * FROM #SH
	 UNION ALL
	 SELECT * FROM #OO

END
