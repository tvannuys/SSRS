
--------------------------------------------------------------------------------
--	SR# 8062 - 
--	James Tuttle
--	02/20/2013
--
--	PURPOSE: A subscription that Email out on the first day of 
--			a new month. Report on the prior month's quotes.
--			MONTHLY is what Steve Miller wanted.
--
--
--
--------------------------------------------------------------------------------


ALTER PROC JT_Weekly_New_Quotes_SteveMiller
 @BeginDate varchar(10)
,@EndDate varchar(10) 
AS
BEGIN 
--------------------------------------------------------------------------------
	-- Beginning day of the month
	SET @BeginDate = dateadd(s,-1,dateadd(mm,datediff(mm,0,getdate())-1,0))	
	-- Last day of the prior month
	SET @EndDate = dateadd(s,-1,dateadd(mm,datediff(mm,0,getdate()),0))
 --------------------------------------------------------------------------------
DECLARE @SQL AS varchar(MAX)
SET @SQL ='

	SELECT *
	FROM OPENQUERY(GSFL2K,
		''SELECT ohco		AS Company#
				,ohloc		AS Quote_Loc
				,smname		AS Rep
				,ohcust		AS Cust_Number
				,cmname		AS Customer
				,ohord#		AS Quote#
				,ohcont		AS Cust_Contact
				,vmname		AS Vendor
				,olitem		AS Product
				,oldesc		AS Description
				,olpric		AS Price
				,olqord		AS Quantity
				,olbluo		AS Bill_Units_Order
				,olum2		AS UM
				,olpric		AS BIll_Unit_Price
				,ohodat		AS Orig_Qt_Date
				,ohddat		AS Exp_Date
				,ohpo#		AS PO#
				,otcmt1		AS Sidemark 
				,oleprc		AS Unit_SubTotal
				,ohemds		AS QT_SubTotal
	
		 FROM qshead qh 
		 JOIN qsline ql ON 
			( qh.ohco = ql.olco
				AND qh.ohloc = ql.olloc
				AND qh.ohord# = ql.olord#
				AND qh.ohrel# = ql.olrel#
				AND qh.ohcust = ql.olcust)
		LEFT JOIN qstext qt ON 
 			( qh.ohco = qt.otco
				AND qh.ohloc = qt.otloc
				AND qh.ohord# = qt.otord#
				AND qh.ohrel# = qt.otrel#
				AND qh.ohcust = qt.otcust
				AND otseq# = 0 AND ottseq = 1)
		JOIN custmast cm ON cm.cmcust = qh.ohcust
		LEFT JOIN salesman sm ON sm.smno = qh.ohslsm
		JOIN vendmast vm ON vm.vmvend = ql.olvend
		WHERE qh.ohodat >=  ' + '''' + '''' +@BeginDate + '''' + ''''+ '   
			AND qh.ohodat <=  ' + '''' + '''' + @EndDate + '''' + ''''+ '
			
			/*AND qt.ottseq = 1
			AND qt.otseq# = 0 */
		ORDER BY qh.ohco
				,qh.ohloc
				,qh.ohord#
		'')
	'
	EXEC (@SQL)
END


--	JT_Weekly_New_Quotes 01012013, 01312013