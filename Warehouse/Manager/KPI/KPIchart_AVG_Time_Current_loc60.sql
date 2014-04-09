
CREATE PROC [dbo].[KPIchart_AVG_Time_Current_loc60] AS 
	
---------------------------------------------------------------------------------------------
--===========================================================================================	
--
-- GET AVERAGE TIME PULLED FOR THE MONTH	
--
--===========================================================================================
---------------------------------------------------------------------------------------------
---------------------------------
--
--	C = current time period
--
---------------------------------
	
 WITH CTEtime AS
 (   
SELECT rfco
	  ,rfloc
	  ,rfcust
	  ,CAST(rfotime as INT) as rfotime
	  ,CAST(rptime as INT) as rptime
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfcust
							/*	,rfoord#
								,rforel#	*/
								,rfotime
								,rptim
							FROM rfwillchst
							WHERE rfloc IN (60,42,59)
								AND rfodate BETWEEN ''01/01/2014'' AND ''01/31/2014'' 
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
					')
GROUP BY rfco
		,rfloc
		,rfcust
		--,rfoord#
		--,rforel#
		,rfotime
		,rptime
--ORDER BY rfcust
--		,rfotime
)		

SELECT    CONVERT(CHAR(20), DATEADD(SECOND, AVG(DATEDIFF(SECOND,
          CONVERT(DATETIME,CONVERT(VarCHAR(4),rfotime/10000)+':'
         +CONVERT(VARCHAR(4),(rfotime/100)%100)+':'
         +CONVERT(VARCHAR(4),rfotime%100),8),
          CONVERT(DATETIME,CONVERT(VarCHAR(02),rptime/10000)+':'
         +CONVERT(VARCHAR(4),(rptime/100)%100)+':'
         +CONVERT(VARCHAR(4),rptime%100),8))),
          CONVERT(DATETIME, '00:00:00', 113)),8)                  
     AS ElapsedTime
FROM CTEtime

/*
---------------------------------------------------------------------------------------------------------------------------
-- KEEP FOR DETAILS REPORTING
---------------------------------------------------------------------------------------------------------------------------


SELECT *
, CONVERT(varchar(8),cast(
    cast(
       substring(right('000000'+cast(rptime as varchar),6),1,2)
       + ':' +
       substring(right('000000'+cast(rptime as varchar),6),3,2)
       + ':' +
       substring(right('000000'+cast(rptime as varchar),6),5,2) 
    as datetime) - --Do the math on the rptime(End) and rfotime(start) time to get the elapsed time
    cast(
       substring(right('000000'+cast(rfotime as varchar),6),1,2)
       + ':' +
       substring(right('000000'+cast(rfotime as varchar),6),3,2)
       + ':' +
       substring(right('000000'+cast(rfotime as varchar),6),5,2) 
    as datetime)
  as time)) as ElapsedTime
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfcust
							/*	,rfoord#
								,rforel#	*/
								,rfotime
								,rptime
							FROM rfwillchst
							WHERE rfloc IN (60,42,59)
								AND rfodate = CURRENT_DATE - 3 days
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
					')
GROUP BY rfco
		,rfloc
		,rfcust
		--,rfoord#
		--,rforel#
		,rfotime
		,rptime
ORDER BY rfcust
		,rfotime
		
-------------------------------------------------------------------------------------------------------------------------------			
		
SELECT *
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfcust
							 	,rfoord#
								,rforel#	
								,rfotime
								,rptime
							FROM rfwillchst
							WHERE rfloc IN (60,42,59)
								AND rfodate = CURRENT_DATE - 3 days
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							--	AND rfoord# = 34804
					')
ORDER BY rfcust
		,rfotime
*/
-----------------------------------------------------------------------------------------------------------------------------------

GO

