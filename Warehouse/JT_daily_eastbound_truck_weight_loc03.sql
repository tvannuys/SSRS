USE [JAMEST]
GO

/****** Object:  StoredProcedure [dbo].[JT_daily_eastbound_truck_weight_loc03]    Script Date: 07/17/2012 12:28:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****************************************************************
* Programmer: James Tuttle		Date:06/12/2012					*
*																*
* Report for Eddie T and Mary N:								*
* Purpose: to look at the routes for all co and loc to see		*	
*  what the weights are at 3pm instead of later in the night	*
*																*
*****************************************************************/


  ALTER PROC [dbo].[JT_daily_eastbound_truck_weight_loc03] AS
  BEGIN
	SELECT * 
	FROM OPENQUERY(GSFL2K,
		'SELECT olico
				,oliloc
				,olord#
				,olrel#
				,olitem
				,ohrout
				,ortrt
				,olqshp
				,ohotyp
				,imwght
				,SUM(olqshp * imwght) AS WEGHT
		FROM ooline ol
		JOIN oohead oh
			ON (ol.olco = oh.ohco
				AND ol.olloc = oh.ohloc
				AND ol.olord# = oh.ohord#
				AND ol.olrel# = oh.ohrel#
				AND ol.olcust = oh.ohcust)
		JOIN ooroute rt
			ON ( rt.ortco = oh.ohco
					AND rt.ortloc = oh.ohloc
					AND rt.ortord = oh.ohord#
					AND rt.ortrel = oh.ohrel#)
		JOIN itemmast im
			ON ol.olitem = im.imitem
		WHERE (oh.ohrout IN (''50-03'',''41-03'',''57-03'',''303'',''303P'',''303S'')  OR (rt.ortrt IN( ''50-03'',''303'')))
			AND ol.oliloc IN (50,41,57,52)
			AND oh.ohcrhl != ''Y''
			AND ol.olinvu NOT IN (''B'',''T'')
			AND oh.ohsdat <= CURRENT_DATE + 6 DAYS
	
		GROUP BY olico
				,oliloc
				,olord#
				,olrel#
				,olitem
				,imwght
				,olqshp
				,ohrout
				,ortrt
				,ohotyp
		ORDER BY olico
				,oliloc
				,ohrout	
				,SUM(olqshp * imwght) DESC
		')
 END






GO


