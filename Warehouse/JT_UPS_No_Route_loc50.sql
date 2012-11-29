USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_UPS_No_Route_loc50]    Script Date: 11/29/2012 14:24:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/************************************************
*												*
*	Programmer: James Tuttle					*
*	Date: 02/17/2012							*
*	------------------------------------------	*
*												*
*	Catch order out of loc50 for via code 7 UPS	*
*	and no route.								*
*************************************************/
---------------------------------------------------
-- James Tuttle
-- 11/29/2012
-- Added VIA Code 'A' with 7
---------------------------------------------------

ALTER PROC [dbo].[JT_UPS_No_Route_loc50] AS

SELECT *
FROM OPENQUERY (GSFL2K,'SELECT ohco as co
								,ohloc as loc
								,ohord# as order
								,ohrel# as release
								,ohviac as via
								,ohvia as via_desc
								,ohrout as route
						FROM oohead oh
						INNER JOIN ooline ol
							ON oh.ohco = ol.olco
							AND oh.ohloc = ol.olloc
							AND oh.ohord# = ol.olord#
							AND oh.ohrel# = ol.olrel#
							AND oh.ohcust = ol.olcust
						WHERE ohviac IN (''7'',''A'')
							AND ohrout = '' ''
							AND ol.oliloc = 50
							AND ol.olbyp != ''B''
						GROUP BY ohco
								,ohloc
								,ohord#
								,ohrel#
								,ohviac
								,ohvia
								,ohrout
				')


GO


