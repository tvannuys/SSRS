
/*********************************************************
**														**
** SR# 3845 and SR# 7083								**
** Programmer: James Tuttle		Date: 01/15/2013		**
** ---------------------------------------------------- **
** Purpose:		Create an automated report for Inventory**
**	Control (Colleen B) so she is not having to collect	**
**	all the data. SQL will run a SP JT_CC_QTR to get 	**
**	the data from the SQL table that has a nightly Job	**
**	that runs to fill the tanle with the data:			**
**	JT_CycleCountReport_BuildTableData_sp				**
**********************************************************/



ALTER PROC JT_CC_QTR 



@StartDate varchar(10)
, @EndDate varchar(10)

AS 
--	DECLARE @sql varchar(4000)

SET DATEFORMAT mdy		
DECLARE @sql varchar(max) 
SET @sql = ' 
SELECT
  CycleCountReport.Co
  ,CycleCountReport.Loc
  ,CycleCountReport.[Date]
  ,CycleCountReport.Measurement
  ,CycleCountReport.[Value]

FROM
  CycleCountReport
  
WHERE CycleCountReport.[Date] BETWEEN ''' + @StartDate  + ''' AND '''  + @EndDate  + '''

'

EXEC (@sql)

-- JT_CC_QTR '10/01/2012','12/31/2012'
  

