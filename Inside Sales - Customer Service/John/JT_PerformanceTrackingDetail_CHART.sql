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

ALTER PROC  [dbo].[JT_PerformanceTrackingDetail_CHART] AS
BEGIN
 SELECT dt			AS [Date]
	   ,[Month]		AS [Month]
	   ,[Year]		AS [Year]
	   ,utuser		AS [User]
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
	'SELECT MONTH(utdate) || ''/'' || DAY(utdate) || ''/'' || YEAR(utdate) AS dt
		   ,MONTHNAME(utdate) AS Month
		   ,YEAR(utdate)	  AS Year
		   ,utuser
		   ,utoent
		   ,utoedt
		   ,utocan
		   ,utcusi
		   ,utitmi
		   ,utspci
		   ,utinvi
		   ,utmsls
		   ,utqent
		   ,utqcan
	
	FROM usertrac ut
	LEFT JOIN userxtra ux ON ux.usxid = ut.utuser
	LEFT JOIN prempm em on em.ememp# = ux.usxemp#
	
	WHERE utdate >=  CURRENT_DATE - 3 YEARS
		AND ux.usxicat = ''!''  
	
	ORDER BY utdate 
	')
END


-- JT_PerformanceTracking_DATASOURCE 
GO


