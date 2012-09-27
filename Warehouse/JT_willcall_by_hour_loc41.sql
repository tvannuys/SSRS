
--CREATE PROC JT_willcall_by_hour_loc41 AS

/* -----------------------------------------------------*
**														*
** -----------------------------------------------------*
** 														*
**------------------------------------------------------*
*/
-- Main Select to AS400 for the details
WITH CTE AS
(
	select ohprlo, 
	   ohco,
	   ohloc, 
	   ohord#, 
	   ohrel#, 
	   ohcust, 
	   ohviac, 
	   ohvia, 
	   ohsdat, 
	   ohticp, 
	   ohdtp, 
	   ohttp,
	   olseq#, 
	   olitem, 
	   olqshp
	FROM OPENQUERY (GSFL2K, 'SELECT *
					FROM oohead JOIN ooline ON ohco = olco
						AND ohloc = olloc
						AND ohord# = olord#
						AND ohrel# = olrel#
					WHERE ohviac = ''1''
						AND ohdtp = CURRENT_DATE
						AND ohprlo IN(41, 52, 57)
						AND ohotyp NOT IN(''SA'', ''PR'')
					ORDER BY ohttp 
				')
)

--SELECT * FROM CTE
-- Group details by the hour and counts
-- The Left(Right('00000')) will add a Zero if it is before 12xx 
SELECT LEFT(RIGHT('00000' + CONVERT(varchar,ohttp), 6),2) as [Hour], COUNT(ohttp) as Lines
FROM CTE
GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,ohttp), 6),2)
order by [Hour]


