
--------------------------------------------------------------------------------
--	SR# 4980 - 
--	James Tuttle
--	11/16/2012
--
--	PURPOSE: A subscription that Email out on Friday at 5PM
--			of that week's quotes written.
--
--
--
--
--------------------------------------------------------------------------------


ALTER PROC JT_Weekly_New_Quotes 
 @BeginDate varchar(10)
,@EndDate varchar(10) 
AS
BEGIN 

	-- Last Saturday's date
	SET @BeginDate = CONVERT(VARCHAR(10),dateadd(dd,-6,datediff(dd,0,getdate())),101)	
	-- Today's date [Friday]
	SET @EndDate = CONVERT(VARCHAR(10),GETDATE(),101)	
 
DECLARE @SQL AS varchar(4000)
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
		 JOIN qstext qt ON 
 			( qh.ohco = qt.otco
				AND qh.ohloc = qt.otloc
				AND qh.ohord# = qt.otord#
				AND qh.ohrel# = qt.otrel#
				AND qh.ohcust = qt.otcust)
		JOIN custmast cm ON cm.cmcust = qh.ohcust
		JOIN salesman sm ON sm.smno = qh.ohslsm
		JOIN vendmast vm ON vm.vmvend = ql.olvend
		WHERE qh.ohodat >=  ' + '''' + '''' +@BeginDate + '''' + ''''+ '   
			AND qh.ohodat <=  ' + '''' + '''' + @EndDate + '''' + ''''+ '
			AND qt.ottseq = 1
			AND qt.otseq# = 0
		ORDER BY qh.ohco
				,qh.ohloc
				,qh.ohord#
		'')
	'
	EXEC (@SQL)
END


--	JT_Weekly_New_Quotes 11102012, 11162012