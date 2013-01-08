

CREATE PROC JT_WCC_Time_Details_loc50 AS
BEGIN
	SELECT rfco AS Co
	 ,rfloc AS Loc
	 ,rfcust AS Cust#
	 ,CONVERT(varchar(8),cast(
			cast(
			   substring(right('000000'+cast(rfotime as varchar),6),1,2)
			   + ':' +
			   substring(right('000000'+cast(rfotime as varchar),6),3,2)
			   + ':' +
			   substring(right('000000'+cast(rfotime as varchar),6),5,2) 
			as DATETIME) AS time)) AS StartTime
	 ,CONVERT(varchar(8),cast(
			cast(
			   substring(right('000000'+cast(rptime as varchar),6),1,2)
			   + ':' +
			   substring(right('000000'+cast(rptime as varchar),6),3,2)
			   + ':' +
			   substring(right('000000'+cast(rptime as varchar),6),5,2) 
		as DATETIME) AS time)) AS EndTime
	--Do the math on the rptime(End) and rfotime(start) time to get the elapsed time------------
	, CONVERT(varchar(8),cast(
			cast(
			   substring(right('000000'+cast(rptime as varchar),6),1,2)
			   + ':' +
			   substring(right('000000'+cast(rptime as varchar),6),3,2)
			   + ':' +
			   substring(right('000000'+cast(rptime as varchar),6),5,2) 
			as datetime) 
		- -- Subtraction Sign
			cast(
			   substring(right('000000'+cast(rfotime as varchar),6),1,2)
			   + ':' +
			   substring(right('000000'+cast(rfotime as varchar),6),3,2)
			   + ':' +
			   substring(right('000000'+cast(rfotime as varchar),6),5,2) 
			as datetime)
	  as time)) AS ElapsedTime
	--------------------------------------------------------------------------------------------
		FROM OPENQUERY (GSFL2K,'SELECT rfco 
									,rfloc 
									,rfcust
								/*--,rfoord#
									,rforel#	--*/
									,rfotime  
									,rptime 
								FROM rfwillchst
								WHERE rfloc = 50
									AND rfodate = CURRENT_DATE 
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
END
