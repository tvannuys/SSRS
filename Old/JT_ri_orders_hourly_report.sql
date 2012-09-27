
--CREATE PROC JT_ri_orders_hourly AS

/* -----------------------------------------------------*
** James Tuttle 5/19/2011		Created: 6/17/2009		*
** -----------------------------------------------------*
** 	Report is to find new IR or RI Order Types written	*
**   after the last hour the report was ran				*
**------------------------------------------------------*
*/
-- RUN ON THE HOUR --

-- Drop the TEMP TABLE
IF OBJECT_ID ('tempdb,#test') is not null
DROP table #test

-- Create the TEMP TABLE
CREATE TABLE #test (Company int, Location int, [Date] DATE, [Order] INT, Release INT, [USER] VARCHAR(10));
GO
-- INSERT GARTMAN Results into TEMP TABLE
INSERT INTO #test (Company, Location, [Date],[Order], Release,[USER])

-- Query AS400 for order types RI & IR
SELECT ohco 'Company',
	ohloc 'Location',
	ohsdat 'Date',
	ohord# 'Order',
	ohrel# 'Release',
	ohuser 'User'
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead
WHERE ohotyp IN(''RI'', ''IR'')
')

-- Compare what is in TEMP TABLE but not in the ri_orders local table
-- This will be the new written orders to Email
WHERE ohord# NOT IN (SELECT [Order] FROM JAMEST.dbo.ri_order )

-- Insert query results into local table to Email 
INSERT INTO JAMEST.dbo.JT_ri_results 
SELECT *
FROM #test 
/*
-- Insert new addition into main local table 
-- to compare for the next query
INSERT INTO dbo.ri_order 
SELECT *
FROM dbo.JT_ri_results 

-- Clear out the results table
DELETE 
FROM dbo.JT_ri_results 

*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
==   TESTING QUERIES
==
-->>>>>>  select * from #test

-->>>>>>   SELECT * FROM dbo.ri_order 

-->>>>>>		DELETE From dbo.ri_order

-->>>>>> SELECT * FROM JT_ri_results

-->>>>>>		DELETE From JT_ri_results
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/