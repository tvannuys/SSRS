
/* Count on YTD for Loc50 orders to the Docks */

WITH CTE AS

(
SELECT * 
FROM OPENQUERY (GSFL2K, 'SELECT shsdat,
								slico,
								sliloc,
								shcust,
								cmname,
								shord#,
								shviac,
								shvia
						FROM shhead JOIN shline ON shco = slco
												AND shloc = slloc
												AND shord# = slord#
												AND shrel# = slrel#
							JOIN custmast ON cmcust = shcust
						WHERE shviac NOT IN(''3'', ''4'', ''A'',''7'',''2'',''9'',''+'',''%'',''@'',''#'',''-'',''.'',''T'',''1'',''R'',''6'',''0'',''X'','' '')
								AND sliloc = 50
								AND shsdat >= ''2010-07-18''
								AND shsdat <= ''2011-07-18''
						')

) 

--SELECT * FROM CTE

SELECT COUNT(shcust) as [count],CTE.shviac, CTE.shvia, CTE.shcust, CTE.cmname
FROM CTE
Group By CTE.shviac, CTE.shvia, CTE.shcust, CTE.cmname
Order By count DESC
















