USE [GartmanReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*==============================================================================
-- SR 14540 
-- Thomas Van Nuys
-- 09/27/2013
--
-- PURPOSE:
--    Query all open orders that are 'SA' and 'DP' order types for the  
--	members of the A&D group
--	

1000121	BRAD RAINS
1000214	BRAD RAINS
6101245	BRAD RAINS  SAMPLES
1002100	GLENN OKADA   SAMPLES  15
4102100	GLENN OKADA  SAMPLES ONLY
6102100	GLENN OKADA  SAMPLES ONLY
1002101	JEFFERY TONG  SAMPLES
1002135	JILL SHAW     SAMPLES  16
1002001	MIKE PIAZZA    SAMPLES
6100500	TONJA DICENZO SAMPLES
6142088	TONJA DICENZO SAMPLES
1002118	TONJA DICENZO SAMPLES 506

--
--
--==============================================================================*/

alter PROC [dbo].[spOpenADSampleOrders] AS
BEGIN
SELECT ohotyp		AS Order_Type
	  ,cmslmn		AS Salesman
	  ,smname		AS Salesman_Name
	  ,Order_Date	AS Order_Date
	  ,ohvia		AS Via
	  ,fullorder	AS Order#
	  ,cmcust		AS Customer#
	--  ,RIGHT(test,3) AS Test
	  ,cmname		AS Customer
	  ,olitem		AS Item
	  ,oldesc		AS [Description]
	  ,olqshp		AS QTY_Ship
	  ,olqbo		AS QTY_BO
	  ,Ship_Date	AS Ship_Date
	FROM OPENQUERY(GSFL2K, '
		SELECT ohotyp
			  ,cmslmn
			  ,smname
			  ,MONTH(ohodat)|| ''/'' || DAY(ohodat)|| ''/'' || YEAR(ohodat) as Order_Date
			  ,ohvia
			  ,ohco || ''-'' || ohloc || ''-'' || olord# || ''-'' || ohrel# as FullOrder
			  ,cmcust
			  ,cmname
			  ,olitem
			  ,oldesc
			  ,olqshp
			  ,olqbo
			  ,MONTH(ohsdat)|| ''/'' || DAY(ohsdat)|| ''/'' || YEAR(ohsdat) as Ship_Date
		FROM oohead oh
		JOIN ooline ol ON (oh.ohco = ol.olco
							AND oh.ohloc = ol.olloc
							AND oh.ohord# = ol.olord#
							AND oh.ohrel# = ol.olrel#
							AND oh.ohcust = ol.olcust)
		JOIN itemmast im ON im.imitem = ol.olitem
		JOIN custmast cm ON cm.cmcust = ol.olcust 
		JOIN salesman sm ON cm.cmslmn = sm.smno
		WHERE oh.ohotyp IN(''DP'',''SA'')
		
		and cmcust in (''1000121'',''1000214'',''6101245'',''1002135'',''6100500'',''6142088'',''1002118'',''1002001'',''1002101'',''1002100'',''4102100'',''6102100'')
	
		ORDER BY cm.cmname
				,oh.ohodat DESC
		')

END



GO


