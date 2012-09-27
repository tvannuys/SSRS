
--CREATE PROC JT_willcall_by_hour

/* -----------------------------------------------------*
**														*
** -----------------------------------------------------*
** 														*
**------------------------------------------------------*
*/

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
						AND ohdtp = ''2011-07-19'' 
						AND ohprlo = 50
					ORDER BY ohttp 
				')
)

SELECT LEFT(RIGHT('00000' + CONVERT(varchar,ohttp), 6),2) as T, COUNT(ohttp) as C
FROM CTE
GROUP BY LEFT(RIGHT('00000' + CONVERT(varchar,ohttp), 6),2)



/*SELECT substring(ohttp,1,2) as [Hour], COUNT(ohttp) as Lines 
FROM CTE
GROUP BY ohttp

SELECT *
FROM CTE
*/


/*******************************************************************************************************************************************************************
-- VFP Code

	Select ohprlo, ohco, ohloc, ohord_, ohrel_, ohcust, ohviac, ohvia, ohsdat, ohticp, ohdtp, ohttp, Val(Left(Padl(Alltrim(Str(ohttp)),6,"0"),2)) As Hour,  ;
			olseq_, olitem, olqshp 
	From cOOhead, cOOline 
	Where ohord_=olord_ And ohrel_=olrel_ And ;
			(m.locTA=ohprlo And m.coTA=ohco) ;
			And ohdtp=m.date And ohviac="1"  
	Order By ohttp Into Cursor TAPMwillcallsO
	

	Select Val(Left(Padl(Alltrim(Str(ohttp)),6,"0"),2)) As Hour, Count(ohttp) As LineS 
	From TAPMwillcallsO  
	Group By Hour Into Cursor TAPMoTime
	
	
	
		Select Hour, Sum(LineS) As LineS ;
			FROM (Select * From TAPMoTime Union All Select * From TAPMsTime) uni;
			GROUP By Hour ;
			into Cursor TAPMtime
	**************************************************************************************************************************************************************/