USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_Weekly_New_Quotes_Sidemarks]    Script Date: 09/26/2013 13:46:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------------------------
--	SR# 4980 - 
--	James Tuttle
--	11/16/2012
--
--	PURPOSE: A subscription that Email out on Friday at 5PM
--			of that week's quotes written.
--==============================================================================
--  James Tuttle  Date: 05/13/2013
--	SR# 10748
--  primary grouping on the Sidemark, then quotes within the Sidemark, 
--  so we can see where we have multiple quotes on the same job
--
--==============================================================================
--  Thomas  Date: 09/26/2013
--	SR# 14533    
--  create a version that allows for a 'days back' parameter 
--  allows a single report and store procedure to address the weekly quotes and 
--     user desire to have a running 6 months report
--
--==============================================================================


ALTER PROC [dbo].[JT_Weekly_New_Quotes_Sidemarks] 
 @DaysBack int

AS
BEGIN 

declare @BeginDate varchar(10)
declare @EndDate   varchar(10)


	-- Last Saturday's date
	SET @BeginDate = CONVERT(VARCHAR(10),dateadd(dd,(@DaysBack * -1),datediff(dd,0,getdate())),101)	
	-- Today's date [Friday]
	SET @EndDate = CONVERT(VARCHAR(10),GETDATE(),101)	
 
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
			/*	,vmname		AS Vendor				*/
			/*	,olitem		AS Product				*/
			/*	,oldesc		AS Description			*/
			/*	,olpric		AS Price				*/
			/*	,olqord		AS Quantity				*/
			/*	,olbluo		AS Bill_Units_Order		*/
			/*	,olum2		AS UM					*/
			/*	,olpric		AS BIll_Unit_Price		*/
				,ohodat		AS Orig_Qt_Date
				,ohddat		AS Exp_Date
				,ohpo#		AS PO#
				,otcmt1		AS Sidemark 
			/*	,oleprc		AS Unit_SubTotal		*/
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
		GROUP BY otcmt1
				,ohord#
				,ohco		
				,ohloc		
				,smname		
				,ohcust		
				,cmname		
				,ohord#		
				,ohcont	
				,ohodat		
				,ohddat		
				,ohpo#		
				,otcmt1		
				,ohemds			
				
		ORDER BY otcmt1
				,ohord#
			
		'')
	'
	EXEC (@SQL)
END


--	JT_Weekly_New_Quotes_Sidemarks 05052012, 05122013
GO


