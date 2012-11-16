
-------------------------------------------------------------------------------------------

-- SR# 4585
-- James Tuttle
-- Date: 10/12/2012
---------------------------------------------------------------------------------------------
-- Purpose:
-- Create a PARM driven look-up query
-- so Tami in sales can look-up any
-- quotes that get purged to the 
-- history files in Gartman if expired
---------------------------------------------------------------------------------------------
-- James Tuttle  11/1/12
-- Per Joe F 11/1/12
-- Adding PARMS ITEM and JobName
-- Adding fields PO# and Due Date
---------------------------------------------------------------------------------------------




 ALTER PROC JT_QuoteHistory
--==========================================================================
		@cust as varchar(10)		= '%'		-- PARMS to search by
 		,@qt as varchar(6)			= '%'		-- but as 'OR'. only of one
 		,@item as varchar(25)		= '%'		-- and only one.
		,@jobName as varchar(15)	= '%'
--==========================================================================
AS

DECLARE @sql varchar(max)


SET @sql = '		
SELECT *
FROM OPENQUERY(GSFL2K,
''SELECT ohco		AS Company#
		,ohloc		AS Quote_Loc
		,ohord#		AS Quote#
		,ohcont		AS Cust_Contact
		,olitem		AS Product
		,olpric		AS Price
		,olqord		AS Quantity
		,ohodat		AS Orig_Qt_Date
		,ohddat		AS Exp_Date
		,ohpo#		AS PO#
		,otcmt1		AS Sidemark 
 FROM hqshead hqh 
 JOIN hqsline hql ON 
	( hqh.ohco = hql.olco
		AND hqh.ohloc = hql.olloc
		AND hqh.ohord# = hql.olord#
		AND hqh.ohrel# = hql.olrel#
		AND hqh.ohcust = hql.olcust)
 JOIN hqstext hqt ON 
 	( hqh.ohco = hqt.otco
		AND hqh.ohloc = hqt.otloc
		AND hqh.ohord# = hqt.otord#
		AND hqh.ohrel# = hqt.otrel#
		AND hqh.ohcust = hqt.otcust)

 WHERE ((ohcust = ' + '''' + '''' + @cust + '''' + '''' + ')
	 OR ( ohord# = ' + '''' + '''' + @qt + '''' + '''' + ' )	
	 OR ( olitem = ' + '''' + '''' + @item + '''' + '''' + ' )	
	 OR ( otcmt1 = ' + '''' + '''' + @jobName + '''' + '''' + '  
			AND otseq# = 1 ))
	AND hqt.ottseq = 1
	AND hqt.otseq# = 0		
	'')
'


EXEC(@sql)


-- JT_QuoteHistory '1000001',0,'',''
--4120100