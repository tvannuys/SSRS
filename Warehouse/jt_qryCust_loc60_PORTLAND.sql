--------------------------------------------------------
-- This query takes the adr3 with city and state
--  and from the Right create the two fields for
-- City and State from the data
--
-- James Tuttle 4/22/2011
--------------------------------------------------------


declare @table table (col varchar(100))
insert @table values ('SOMEWHERE            ST')
select COL,
		RTRIM(reverse(substring(reverse(col),3,len(col)))) FirstPart,
		REVERSE(left(reverse(col),2)) SecondPart
from @table 







