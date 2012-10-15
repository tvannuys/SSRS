

-- SR# 4585

-- ALTER PROC JT_QuoteHistory

		@cust as varchar(10)		= '%'
		,@qt as varchar(6)			= '000000'
		--,@BeginDate as varchar(10)
		--,@EndDate as varchar(10)
AS

DECLARE @sql varchar(3000)


SET @sql = '		
SELECT *
FROM OPENQUERY(TSGSFL2K,
''SELECT ohco
		,ohloc
		,ohord#
		,ohrel#
		,ohcust
		,olitem
		,olpric
 FROM hqshead hqh 
 JOIN hqsline hql ON 
	( hqh.ohco = hql.olco
		AND hqh.ohloc = hql.olloc
		AND hqh.ohord# = hql.olord#
		AND hqh.ohrel# = hql.olrel#)
 
 WHERE ((ohcust = ' + '''' + '''' + @cust + '''' + '''' + ') OR ( ohord# = ' + '''' + '''' + @qt + '''' + '''' + ' ))	
'')


'

EXEC(@sql)



-- JT_QuoteHistory 1021405,NULL