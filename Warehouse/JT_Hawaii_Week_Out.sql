USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_Hawaii_Week_Out]    Script Date: 2/13/2014 1:34:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/************************************************************************
*																		*
*	Programmer: James Tuttle											*
*	Date: 02/23/2012													*
*	------------------------------------------------------------------	*
*																		*
*	Run report on Thursday at 5PM and look out to the following			*
*	Wednesday for other orders that are not in SHIPPED or IN_TRANS		*
*	status. This will allow shipping to gather and sold orders that		*
*	was received on Thursday.											*
*																		*
*************************************************************************/


 ALTER PROC [dbo].[JT_Hawaii_Week_Out] As

SELECT *
FROM Openquery(GSFL2K,'SELECT ohco AS Co
							,ohloc AS Loc
							,MONTH(ohsdat) || ''/'' || DAY(ohsdat) || ''/'' || YEAR(ohsdat) AS ship_Date
							,ohord# AS Order
							,ohrel# AS Release
							,ohrout AS Route
							,olinvu AS Status
							,ohemds	AS Sub_Total
							,CEILING(SUM(olqord * imwght))	AS Weight
							,cmname	AS Customer

						FROM oohead oh
						LEFT JOIN ooline ol
							ON oh.ohco = ol.olco
							AND oh.ohloc = ol.olloc
							AND oh.ohord# = ol.olord#
							AND oh.ohrel# = ol.olrel#
							AND oh.ohcust = ol.olcust
						LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
						LEFT JOIN itemmast im ON im.imitem = ol.olitem

						WHERE ol.oliloc IN (50,52,41)
							AND (oh.ohrout = ''50-83'' OR oh.ohrout = ''41-83'')
							AND oh.ohsdat >= CURRENT_DATE
							AND oh.ohsdat <= CURRENT_DATE + 6 DAYS
							AND ol.olinvu NOT IN (''W'', ''T'')

						GROUP BY ohco
							,ohloc
							,MONTH(ohsdat) || ''/'' || DAY(ohsdat) || ''/'' || YEAR(ohsdat) 
							,ohord#
							,ohrel#
							,ohrout 
							,olinvu
							,ohemds
							,cmname

						ORDER BY oh.ohco, oh.ohloc
							')

GO


