USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_PerformanceTrackingDetail_CHART]    Script Date: 09/25/2013 12:38:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************************
**																				**
** SR# 14048		Date: 09/25/2013											**
** Programmer: James Tuttle														**
** ---------------------------------------------------------------------------- **
** Purpose:		Data source for John B to build the Excel Pivot Table			**
**				data is from Gartman Table that holds the data					**
**																				**
**				File: USERTRAC													**
**																				**
**		ENTER	EDIT	CANCEL	CUST	ITEM	SPEC	INV	   Missed Sale		**
**																				**
**********************************************************************************/
-- 

ALTER PROC  [dbo].[JT_PerformanceTrackingDetail_Monthly] 
	@yearsBack AS varchar(3) = '1' -- years back from the start of the current year | deafult 1
AS
BEGIN
DECLARE @sql AS varchar(4000) = '
 SELECT  Months
	   ,Years
	   ,utoent		AS Enter
	   ,utoedt		AS Edits
	   ,utocan		AS Cancels
	   ,utcusi		AS Cust
	   ,utitmi		AS Item
	   ,utspci		AS Spec
	   ,utinvi		AS Inv
	   ,utmsls		AS Missed_Sale
	   ,utqent		AS Qt_Entered
	   ,utqcan		AS Qt_Canceled
	   
 FROM OPENQUERY(GSFL2K,	
	''SELECT MONTHNAME(utdate) AS Months
		   ,YEAR(utdate)	  AS Years
		   ,SUM(utoent)		  AS utoent
		   ,SUM(utoedt)		  AS utoedt
		   ,SUM(utocan)		  AS utocan
		   ,SUM(utcusi)		  AS utcusi
		   ,SUM(utitmi)		  AS utitmi
		   ,SUM(utspci)		  AS utspci
		   ,SUM(utinvi)		  AS utinvi
		   ,SUM(utmsls)		  AS utmsls
		   ,SUM(utqent)		  AS utqent
		   ,SUM(utqcan)		  AS utqcan
	
	FROM usertrac ut
	LEFT JOIN userxtra ux ON ux.usxid = ut.utuser
	LEFT JOIN prempm em on em.ememp# = ux.usxemp#
	
	WHERE utdate >=  (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) 
						MONTHS - (DAY(CURRENT_DATE)-1) DAYS) -  ' + @yearsBack + '  YEARS
		AND ux.usxicat = ''''!''''  
	
	GROUP BY YEAR(utdate)
			,MONTHNAME(utdate)
	
	ORDER BY YEAR(utdate)
			

	'')' 
END
EXEC (@sql)
--select (@sql)
-- JT_PerformanceTracking_DATASOURCE '1'
GO


