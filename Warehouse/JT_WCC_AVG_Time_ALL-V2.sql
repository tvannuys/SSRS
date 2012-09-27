---------------------------------------------------------------------------------------------
--===========================================================================================	
--
-- GET AVERAGE TIME PULLED FOR THE DAY by all locations	
--
--===========================================================================================
---------------------------------------------------------------------------------------------
--CREATE PROC JT_WccAvgTime_all_loc AS

--DELETE WccAvgTime 
--WHERE Metric = 'WCC Avg Time'
--GO


 WITH CTEtime AS
 (   
SELECT rfco
	  ,rfloc
	  ,rfodate
	  ,rfcust 
	  ,'WCC Avg Time' as Metric
	  ,'WCC Avg Time' as Daily
	  ,CAST(rfotime as INT) as rfotime
	  ,CAST(rptime as INT) as rptime
	  ,(
			SELECT COUNT(x.olritem) FROM OPENQUERY('SELECT x.olritem  
									FROM rfwillchst as x
									WHERE x.rfodate >= ''2011-10-15''
										AND x.rfodate <= CURRENT_DATE
										AND x.rpstat = ''T''
										AND x.rfobin# != ''SHIPD''
									GROUP BY x.olritem
										') AS LineCnt
	FROM OPENQUERY (GSFL2K,'SELECT rfco
								,rfloc
								,rfodate
								,rfcust
							/*	,rfoord#
								,rforel#	*/
								,rfotime
								,rptime
							FROM rfwillchst
							WHERE /*rfloc = 50
								AND*/ rfodate >= ''2011-10-15''
								AND rfodate <= CURRENT_DATE
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
					')
GROUP BY rfco
		,rfloc
		,rfodate
		,rfcust
		/*,rfoord#
		 ,rforel#*/
		,rfotime
		,rptime
/*ORDER BY rfcust
 		,rfotime*/
)		

--INSERT WccAvgTime (rfco,rfloc,rfodate,Metric,Daily,Value)

SELECT  rfco
		 ,rfloc
		 ,rfodate
		 --,rfcust 
		 ,'WCC Avg Time' as Metric
		 ,'WCC Avg Time' as Daily
		 ,CONVERT(CHAR(8), DATEADD(SECOND, AVG(DATEDIFF(SECOND,
			  CONVERT(DATETIME,CONVERT(VarCHAR(4),rfotime/10000)+':'
			 +CONVERT(VARCHAR(4),(rfotime/100)%100)+':'
			 +CONVERT(VARCHAR(4),rfotime%100),8),
			  CONVERT(DATETIME,CONVERT(VarCHAR(02),rptime/10000)+':'
			 +CONVERT(VARCHAR(4),(rptime/100)%100)+':'
			 +CONVERT(VARCHAR(4),rptime%100),8))),
			  CONVERT(DATETIME, '00:00:00', 113)),8)                 
     AS Value
FROM CTEtime
GROUP BY rfco
		,rfloc
		,rfodate
		--,rfcust
		,CTEtime.Metric
		,CTEtime.Daily
ORDER BY rfodate
		,rfco
		,rfloc
		


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
							WHERE rfloc = 50
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
							WHERE /*rfloc = 50
								AND*/ rfodate = CURRENT_DATE 
								AND rpstat = ''T''
								AND rfobin# != ''SHIPD''
							--	AND rfoord# = 34804
					')
ORDER BY rfcust
		,rfotime
*/
-----------------------------------------------------------------------------------------------------------------------------------

--GO