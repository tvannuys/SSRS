

 ALTER PROC [dbo].[JT_Printed_But_Not_Shipped_Loc41] AS

/*------------------------------------------------------*
** James Tuttle											*	
** Date: 8/3/2011										*
**														*
** report for loc41 on orders printed and not all		*
** lines are shipped									*
**														*
**------------------------------------------------------*/



/* Query to look at orders printed but not shipped for Will Call */

SELECT DISTINCT *
	FROM OPENQUERY (GSFL2K, 'SELECT ohprco AS CO,
									ohprlo AS Loc,
									ohord# AS Order,
									ohrel# AS Release,
									ohdtp AS Date_Printed,
									ohviac AS Via_Code,
									ohvia AS Via_Description,
									olinvu AS Status
							FROM oohead JOIN ooline ON ohco = olco
								AND ohloc = olloc
								AND ohord# = olord#
								AND ohrel# = olrel#
							WHERE ohdtp = CURRENT_DATE
								AND ohviac = ''1''
								AND ohticp = ''Y''
								AND ohprlo IN (41, 52, 57)
								AND ohotyp NOT IN (''SA'', ''DP'')
								AND (olinvu = '' '' OR olinvu = ''S'' OR olinvu = ''X'' OR olinvu = ''M'') 
								AND ohprtr != ''PKM''
					')
ORDER BY [Status] DESC
GO


