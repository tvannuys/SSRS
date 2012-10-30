
---------------------------------------------------------------------------------------------
-- James Tuttle
-- 10/29/2012
--
-- Key in a route to see the customers tied to it.
-- This Joins for Parent Routing
---------------------------------------------------------------------------------------------



ALTER PROC JT_cust_route 
	@Route AS varchar(5) = '%'

AS

DECLARE @SQL AS varchar(3000)



SET @SQL ='
	SELECT cmname AS Cust_Name
			,cmcust As Customer#
			,cmvia AS Via_Code
			,cmdrt1 AS Route_1
			,cmdrt2 AS Route_2
			,RTRIM(REVERSE(SUBSTRING(REVERSE(CMADR3),3,LEN(CMADR3)))) AS City
			,REVERSE(LEFT(REVERSE(CMADR3),2)) AS State
			,cmzip AS Zip
	FROM OPENQUERY(GSFL2K,
		''SELECT cmname
				,cmcust
				,cmvia
				,cmdrt1
				,cmdrt2
				,cmadr3
				,cmzip
	FROM custmast cm
	WHERE cm.cmdrt1 = ' + '''' + '''' + @Route + '''' + '''' + '
	ORDER BY cm.cmname
	
	'')
'
	
	EXEC (@SQL)
	
	-- JT_cust_route ORCC2
	
-------------------------
--
-- need to allow lookup
-- for non-cons. routes
--
-------------------------