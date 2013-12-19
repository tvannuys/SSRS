/*********************************************************************************
**																				**
** SR# 13157																	**
** Programmer: James Tuttle	Date: 08/09/2013									**
** ---------------------------------------------------------------------------- **
** Purpose:			Order type 'RA' Created date Greater Than 45 days			**
**				Email by User (just like the VERIFICATION LINE you did for us)	**
**				Company 1 & 2 by User Emailed									**
**				Sent out daily at 8am											**
**																				**
**																				**
**********************************************************************************/

-- 12/18/2013	SR# 16698	James Tuttle
-- 12/19/2013	SR# 16714	James Tuttle

ALTER PROC JT_RA_45DaysOld_byUser AS
BEGIN
 SELECT  OrderDate
		,ohco		AS	[Co]
		,ohloc		AS	[Loc]
		,ohord#		AS	[Order#]
		,ohuser		AS	[User]
 FROM OPENQUERY(GSFL2K,	
	'SELECT MONTH(ohodat) || ''/'' || 
			DAY(ohodat) || ''/'' || 
			YEAR(ohodat)				as OrderDate
		,ohco
		,ohloc
		,ohord#
		,ohuser 
		
	FROM oohead oh
/*	LEFT JOIN ooline ol ON (ol.olco = oh.ohco		*/
/*		    AND ol.olloc = oh.ohloc					*/
/*		    AND ol.olord# = oh.ohord#				*/
/*		    AND ol.olrel# = oh.ohrel#				*/
/*		    AND ol.olcust = oh.ohcust)				*/
		    
	WHERE oh.ohotyp IN (''RA'',''RI'')
		AND oh.ohodat <= CURRENT_DATE - 45 DAYS
		
	ORDER BY ohco
			,ohloc
			,ohuser
			,OrderDate
	')
END

