USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_CC_QTR_KPI_DATASOURCE]    Script Date: 2/13/2014 2:47:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*********************************************************
**														**
** SR# 3845 and SR# 7083								**
** Programmer: James Tuttle		Date: 01/15/2013		**
** ---------------------------------------------------- **
** Purpose:		Create an automated report for Inventory**
**	Control (Colleen B) so she is not having to collect	**
**	all the data. SQL will run a SP JT_CC_QTR to get 	**
**	the data from the SQL table that has a nightly Job	**
**	that runs to fill the table with the data:			**
**	JT_CycleCountReport_BuildTableData_sp				**
**********************************************************/



ALTER PROC [dbo].[JT_CC_QTR_KPI_DATASOURCE] AS

-- SET DATEFORMAT mdy		

SELECT CycleCountReport.Co
  ,CycleCountReport.Loc
  ,CycleCountReport.[Date]
  ,DATENAME(MONTH,CycleCountReport.[Date]) AS [Month]
  ,DATENAME(YEAR,CycleCountReport.[Date]) AS [Year]
  ,CycleCountReport.Measurement
  ,CycleCountReport.[Value]

FROM CycleCountReport
  
WHERE	CycleCountReport.[Date] BETWEEN DATEADD(year,-2,DATEADD(MONTH,datediff(MONTH,-1,GETDATE())-1,0)) 
	AND GETDATE()




GO


