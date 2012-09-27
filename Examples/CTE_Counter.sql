
WITH
cteCounter AS
(--==== Counter rCTE counts from 0 to 11 
SELECT 0 AS N      --This provides the starting point (anchor) of zero  
UNION ALL 
 SELECT N + 1       --This is the recursive part   
FROM cteCounter  WHERE N < 11
)--==== Add the counter value to a start date and you get multiple dates 
SELECT StartOfMonth = DATEADD(mm,N,'2011')   FROM cteCounter;