
DECLARE @YourTable TABLE (StartTimeText int--VARCHAR(10)
                         , EndTimeText int)--VARCHAR(10))

INSERT  INTO @YourTable SELECT  70500, 71002
INSERT  INTO @YourTable SELECT  120501, 141845



SELECT  StartTimeText
		, EndTimeText
        , CONVERT(CHAR(8), 
             CONVERT(DATETIME,STUFF(STUFF(LEFT('00',6 - LEN(EndTimeText)) + EndTimeText,
                           5, 0, ':')
                        , 3, 0, ':'))) - --Do the math on the start and end time to get the elapsed time
            CONVERT(DATETIME,STUFF(STUFF(LEFT('00',6 - LEN(StartTimeText)) + StartTimeText,
                           5, 0, ':')
                        , 3, 0,':')
              , 108)
           AS ElapsedTime
FROM    @YourTable 
----------------------------------------------------------------------------------------------------------
--
-- This from the DB2 as text stored time workes for the WCC
--
--


declare @YourTable table (StartTimeText int, EndTimeText int)
insert into @YourTable select '70500', '71002'
insert into @YourTable select '125402', '151522'


select 
    *,
    cast(
    cast(
       substring(right('000000'+cast(EndTimeText as varchar),6),1,2)
       + ':' +
       substring(right('000000'+cast(EndTimeText as varchar),6),3,2)
       + ':' +
       substring(right('000000'+cast(EndTimeText as varchar),6),5,2) 
    as datetime) - 
    cast(
       substring(right('000000'+cast(StartTimeText as varchar),6),1,2)
       + ':' +
       substring(right('000000'+cast(StartTimeText as varchar),6),3,2)
       + ':' +
       substring(right('000000'+cast(StartTimeText as varchar),6),5,2) 
    as datetime)
    as time) as ElapsedTime
from @YourTable
-------------------------------------------------------------------------------------------------------------------

