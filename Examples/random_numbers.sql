


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

--[JT_Monthly_Vend_Wght_by_Loc_V2] 

ALTER PROC [dbo].[JT_Monthly_Vend_Wght_by_Loc_V2]

-- @BeginDate varchar(10)  ,
-- @EndDate varchar(10) 

AS

DECLARE @BeginDate varchar(10)  ,
		 @EndDate varchar(10)  
		 
-- Get first day of the month 5 months back
SET @BeginDate = CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,-5,GETDATE())),101) 

-- Get end of month from the prior month
SET @EndDate = CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(GETDATE())),GETDATE()),101)

-- START -----------------------------------------------------------------------------------------------------------

-- SQL Server column formatting and math ---------------------------------------------------------------------------
DECLARE @SQL varchar(max)
SET @SQL =
'SELECT	slco AS ''Co''
		,slloc AS ''Loc''
		,lcrnam AS ''Loc Name'' 
		,slvend AS ''Vend #''
		,vmname AS ''Vend Name''
		,CAST((ISNULL(SUM(CASE WHEN MONTH(sldate) = 2 THEN (slqshp * imwght) END),0)) as DECIMAL(10,0)) AS ''Jan Wgt''
		,''     '' AS ''     ''	-- Free space to seperate prior month and averge
		
-- Get average by adding the four months after last month and divide by the four ------------------------------------

		,CAST(((ISNULL(SUM(CASE WHEN MONTH(sldate) = 1 THEN (slqshp * imwght) END),0) 
			+  ISNULL(SUM(CASE WHEN MONTH(sldate) = 12 THEN (slqshp * imwght) END),0)
			+  ISNULL(SUM(CASE WHEN MONTH(sldate) = 11 THEN (slqshp * imwght) END),0)
			+  ISNULL(SUM(CASE WHEN MONTH(sldate) = 10 THEN (slqshp * imwght) END),0)) / 4)as DECIMAL(10,0)) AS ''Avg Wgt''	
				
-- Get the last four months weight after the last month -------------------------------------------------------------

		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = 1 THEN (slqshp * imwght) END),0)as DECIMAL(10,0)) AS ''Dec Wgt''
		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = 12 THEN (slqshp * imwght) END),0) as DECIMAL(10,0))AS ''Nov Wgt''
		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = 11 THEN (slqshp * imwght) END),0)as DECIMAL(10,0)) AS ''Oct Wgt''
		,CAST(ISNULL(SUM(CASE WHEN MONTH(sldate) = 10 THEN (slqshp * imwght) END),0)as DECIMAL(10,0)) AS ''Sep Wgt''
		
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
							AND slloc IN (2,3)	*/
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

		, CAST((ISNULL(SUM(CASE WHEN MONTH(sldate) = 2 THEN (slqshp * imwght) END),0)) as DECIMAL(10,0)) DESC
'
EXEC (@SQL)


GO


