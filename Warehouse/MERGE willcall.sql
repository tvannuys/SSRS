

 ALTER PROC JT_willcall_by_hour_loc50 
 AS	  
/* -----------------------------------------------------*
**						@date date, @hour time, @LineCnt INT								*
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
								AND ohprlo = 50
								AND ohotyp != ''SA''
							ORDER BY ohttp 
						')
		)
		-- Group details by the hour and counts
		-- The Left(Right('00000')) will add a Zero if it is before 12xx 
		SELECT ohdtp as [date], LEFT(RIGHT('00000' + CONVERT(varchar,ohttp), 6),2) as [Hour], COUNT(ohttp) as LineCnt
		FROM CTE
		GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,ohttp), 6),2), ohdtp
		order by [Hour]
		
-- Table is willcall_loc50
	MERGE willcall_loc50 AS wc
	USING CTE AS sf
	ON wc.[date] = sf.[date]
	 AND wc.[hour] = sf.[hour]
	WHEN MATCHED THEN
	-- UPDATE
		UPDATE SET wc.[date] = sf.[date],
					wc.[hour] = sf.[hour],
					wc.LineCnt = sf.LineCnt
	WHEN NOT MATCHED THEN 
	--INSERT
		INSERT ([date], [hour], LineCnt)
		VALUES (sf.[hour], sf.[hour], sf.LineCnt);
GO

EXEC JT_willcall_by_hour_loc50
-- @date, @hour, @LineCnt


