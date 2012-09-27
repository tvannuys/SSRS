
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


 --ALTER PROC JT_Hawaii_Week_Out Asdsp

SELECT *
FROM Openquery(GSFL2K,'SELECT ohco AS Co
							,ohloc AS Loc
							,MONTH(ohsdat) || ''/'' || DAY(ohsdat) || ''/'' || YEAR(ohsdat) AS ship_Date
							,ohord# AS Order
							,ohrel# AS Release
							,ohrout AS Route
							,olinvu AS Status
						FROM oohead oh
						INNER JOIN ooline ol
							ON oh.ohco = ol.olco
							AND oh.ohloc = ol.olloc
							AND oh.ohord# = ol.olord#
							AND oh.ohrel# = ol.olrel#
							AND oh.ohcust = ol.olcust
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
						ORDER BY oh.ohco, oh.ohloc
							')