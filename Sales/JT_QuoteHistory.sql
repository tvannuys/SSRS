
-------------------------------------------------------------------------------------------

-- SR# 4585
-- James Tuttle
-- Date: 10/12/2012
--
-- Purpose:
-- Create a PARM driven look-up query
-- so Tami in sales can look-up any
-- quotes that get purged to the 
-- history files in Gartman if expired
---------------------------------------------------------------------------------------------




  --ALTER PROC JT_QuoteHistory

		@cust as varchar(10)		= '%'
		,@qt as varchar(6)			= '%'
		--,@BeginDate as varchar(10)
		--,@EndDate as varchar(10)
AS

DECLARE @sql varchar(3000)


SET @sql = '		
SELECT *
FROM OPENQUERY(GSFL2K,
''SELECT ohco		AS Company#
		,ohloc		AS Quote_Loc
		,ohord#		AS Quote#
		,ohpo#		AS PO#	
		,ohcont		AS Cust_Contact
		,olitem		AS Product
		,olpric		AS Price
		,olqord		AS Quantity
		,ohodat		AS Orig_Qt_Date
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



-- JT_QuoteHistory 1021405,0