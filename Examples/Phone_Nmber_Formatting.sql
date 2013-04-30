
----------------------------------------------------------------------------------
-- Format phone numbers for IF:
--		1. 1 for long distance			 1(360)555-1212
--	OR  2. Area code and  number only	  (360)555-1212	
--  OR  3. Phone number only				   555-1212
-- ELSE 4. "No Number"						No Number
--
-- REFERENCE:
-- http://www.sqlservercurry.com/2010/11/format-phone-numbers-in-sql-server.html
----------------------------------------------------------------------------------	
	
		,CASE LEN(cmphon)
		WHEN 11 THEN LEFT(cmphon,1)+
			STUFF(STUFF(STUFF(cmphon,1,1,' ('),6,0,') '),11,0,'-')
		WHEN 10 THEN
			STUFF(STUFF(STUFF(cmphon,1,0,' ('),6,0,') '),11,0,'-')
		WHEN 7 THEN
			STUFF(cmphon,4,0,'-')
		ELSE 'No Number'
		END															AS Phone		-- Format with dashes for a phone number format
------------------------------------------------------------------------------------