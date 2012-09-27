

/****************************************************************************
*																			*
*	Programmer: James Tuttle												*
*	Date: 02/06/2012														*
*	--------------------------------------------------------------------	*
*	Purpose:																*
*																			*
*																			*
*																			*
*																			*
*	====================================================================	*
*	Modified BY:															*
*	Moodified Date:															*
*																			*
*****************************************************************************/

ALTER PROC [dbo].[JT_Monthly_Vend_Wght_by_Loc_V2] 


-- @BeginDate varchar(10)  ,
-- @EndDate varchar(10) 

AS

DECLARE @BeginDate varchar(10)  
		,@EndDate varchar(10)  
		,@PrMonth varchar(2)
		,@Month2 varchar(2)
		,@Month3 varchar(2)
		,@Month4 varchar(2)
		,@Month5 varchar(2)
		 
-- Get first day of the month 5 months back
SET @BeginDate = CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,-5,GETDATE())),101) 

-- Get end of month from the prior month
SET @EndDate = CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(GETDATE())),GETDATE()),101)

-- Month columns for report
SET @PrMonth = DATEPART(month,DATEADD(m, -1, GETDATE()))  -- Prior Month || CONVERT(VARCHAR(3), <-----------------------------
SET @Month2 = DATEPART(month,DATEADD(m, -2, GETDATE())) -- Two months back
SET @Month3 = DATEPART(month,DATEADD(m, -3, GETDATE())) -- Three months back
SET @Month4 = DATEPART(month,DATEADD(m, -4, GETDATE())) -- Four months back
SET @Month5 = DATEPART(month,DATEADD(m, -5, GETDATE())) -- Five months back

-- START -----------------------------------------------------------------------------------------------------------

-- SQL Server column formatting and math ---------------------------------------------------------------------------
DECLARE @SQL varchar(max)
SET @SQL =
'SELECT	slco AS ''Co''
		,slloc AS ''Loc''
		,lcrnam AS ''Loc Name'' 
		,slvend AS ''Vend #''
		,vmname AS ''Vend Name''
		,CAST((ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@PrMonth+''+''+'  THEN (slqshp * imwght) END),0)) as DECIMAL(10,0)) AS ''Pr Month''
		,''     '' AS ''     ''	-- Free space to seperate prior month and averge
		
-- Get average by adding the four months after last month and divide by the four ------------------------------------

		,CAST(((ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month2+''+''+' THEN (slqshp * imwght) END),0) 
			+  ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month3+''+''+' THEN (slqshp * imwght) END),0)
			+  ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month4+''+''+' THEN (slqshp * imwght) END),0)
			+  ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month5+''+''+' THEN (slqshp * imwght) END),0)) / 4)as DECIMAL(10,0)) AS ''Avg Wgt''	
				
-- Get the last four months weight after the last month -------------------------------------------------------------

		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month2+''+''+' THEN (slqshp * imwght) END),0)as DECIMAL(10,0)) AS ''Month 2''
		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month3+''+''+' THEN (slqshp * imwght) END),0) as DECIMAL(10,0))AS ''Month 3''
		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month4+''+''+' THEN (slqshp * imwght) END),0)as DECIMAL(10,0)) AS ''Month 4''
		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@Month5+''+''+' THEN (slqshp * imwght) END),0)as DECIMAL(10,0)) AS ''Month 5''
		
-- Get data from AS400 ----------------------------------------------------------------------------------------------	

FROM OPENQUERY(GSFL2K,''SELECT  *
					FROM  shline sl
						INNER JOIN itemmast im
							ON sl.slitem = im.imitem
						INNER JOIN vendmast vm
							ON sl.slvend = vm.vmvend
						INNER JOIN location lc
							ON sl.slco = lc.lcco
								AND sl.slloc = lc.lcloc
					WHERE sl.sldate >=  ' + '''' + '''' +@BeginDate + '''' + ''''+ '   
							AND sl.sldate <=  ' + '''' + '''' + @EndDate + '''' + ''''+ '
							AND sl.slvend != 40000
					/*		AND slco = 1 
							AND slloc IN (2,3)	
							AND slloc = 50
							AND slvend = 12384*/
					'')
-- SQL Server grouping and sort --------------------------------------------------------------------------------------

GROUP BY slco 
		,slloc 
		,lcrnam 
		,slvend 
		,vmname  
ORDER BY slco
		, slloc
-- Sorted off the prior month weight DESC -----------------------------------------------------------------------------

		, CAST((ISNULL(SUM(CASE WHEN MONTH(sldate) = '+''+''+@PrMonth+''+''+' THEN (slqshp * imwght) END),0)) as DECIMAL(10,0)) DESC
'
EXEC (@SQL)
--SELECT @SQL

GO


