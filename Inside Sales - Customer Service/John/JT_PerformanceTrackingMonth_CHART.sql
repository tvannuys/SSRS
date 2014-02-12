

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

ALTER PROC  JT_PerformanceTrackingMonth_CHART AS
BEGIN
 SELECT emco		AS Co
	   ,MONTH(utdate)	AS [Month]
	   ,YEAR(utdate)	AS [Year]
	   ,utoent		AS Enter
	   ,utoedt		AS Edits
	   ,utocan		AS Cancels
	   ,utcusi		AS Cust
	   ,utitmi		AS Item
	   ,utspci		AS Spec
	   ,utinvi		AS Inv
	   ,utmsls		AS Missed_Sale
 FROM OPENQUERY(GSFL2K,	
	'SELECT emco
		   ,utdate 
		   ,utoent
		   ,utoedt
		   ,utocan
		   ,utcusi
		   ,utitmi
		   ,utspci
		   ,utinvi
		   ,utmsls
	
	FROM usertrac ut
	LEFT JOIN userxtra ux ON ux.usxid = ut.utuser
	LEFT JOIN prempm em on em.ememp# = ux.usxemp#
	
	WHERE utdate >=  (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS - (DAY(CURRENT_DATE)-1) DAYS)
		AND em.emshft = ''1'' 
		

		
	GROUP BY emco
	   ,MONTH(utdate)
	   ,YEAR(utdate)
	   ,utoent		
	   ,utoedt		
	   ,utocan		
	   ,utcusi		
	   ,utitmi		
	   ,utspci		
	   ,utinvi		
	   ,utmsls	
	   ,utdate	

	')
END


-- JT_PerformanceTrackingMonth_CHART

-- JT_PerformanceTracking_DATASOURCE