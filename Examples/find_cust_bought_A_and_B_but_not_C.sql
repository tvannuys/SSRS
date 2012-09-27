
/* Find Customers Who Bought "A" and "B" But Not "C" (SQL Spackle)
By Jeff Moden, 2012/03/29 

"SQL Spackle" is a collection of short articles written based on 
multiple requests for similar code. These short articles are NOT
 meant to be complete solutions. Rather, they are meant to 
 "fill in the cracks". 

--Phil McCracken 

--http://www.sqlservercentral.com/articles/T-SQL/88244/
*/
use jamest
go

--===== Conditionally drop the test table to make
     -- reruns in SSMS easier.
     IF OBJECT_ID('tempdb..#Purchase','U') IS NOT NULL
        DROP TABLE #Purchase
;
--===== Create the test table
 CREATE TABLE #Purchase
        (
         PurchaseID     INT IDENTITY(1,1),
         CustomerID     INT,
         ProductCode    CHAR(1)
         PRIMARY KEY CLUSTERED (PurchaseID)
        )
;
--===== Populate the test table with known data.
 INSERT INTO #Purchase
        (CustomerID, ProductCode)
------- Customer #1 precisely meets the criteria.
     -- Bought 'A' and 'B' but not 'C'.
 SELECT 1, 'A' UNION ALL
 SELECT 1, 'B' UNION ALL
------- Customer #2 also meets the criteria.
     -- Bought 'A' and 'B' and somthing else,
     -- but not 'C'.
 SELECT 2, 'A' UNION ALL
 SELECT 2, 'B' UNION ALL
 SELECT 2, 'D' UNION ALL
------- Customer #3 also meets the criteria.
     -- Bought 'A' and 'B' and something else,
     -- but not 'C'.
 SELECT 3, 'A' UNION ALL
 SELECT 3, 'B' UNION ALL
 SELECT 3, 'D' UNION ALL
 SELECT 3, 'A' UNION ALL
 SELECT 3, 'D' UNION ALL
------- Customer #4 doesn't meet the criteria.
     -- Bought 'A' and 'B' but also bought 'C'.
 SELECT 4, 'A' UNION ALL
 SELECT 4, 'B' UNION ALL
 SELECT 4, 'C' UNION ALL
------- Customer #5 doesn't meet the criteria.
     -- Bought 'A' and 'B' and something else,
     -- but also bought 'C'.
 SELECT 5, 'A' UNION ALL
 SELECT 5, 'B' UNION ALL
 SELECT 5, 'A' UNION ALL
 SELECT 5, 'B' UNION ALL
 SELECT 5, 'C' UNION ALL
 SELECT 5, 'D' UNION ALL
------- Customer #6 doesn't meet the criteria.
     -- Bought more than 1 of 'A' and something else
     -- but not 'B'.
 SELECT 6, 'A' UNION ALL
 SELECT 6, 'A' UNION ALL
 SELECT 6, 'D' UNION ALL
 SELECT 6, 'E' UNION ALL
------- Customer #7 doesn't meet the criteria.
     -- Bought more than 1 of 'B' and something else
     -- but not 'A'.
 SELECT 7, 'B' UNION ALL
 SELECT 7, 'B' UNION ALL
 SELECT 7, 'D' UNION ALL
 SELECT 7, 'E'
;

--===== Find Customers that bought either "A" OR "B"
 SELECT CustomerID
   FROM #Purchase
  WHERE ProductCode IN ('A','B')
;

--===== Find Customers that bought either "A" OR "B"
 SELECT CustomerID,
        ProductCount = COUNT(*)
   FROM #Purchase
  WHERE ProductCode IN ('A','B')
  GROUP BY CustomerID
;

     -- and count the DISTINCT number of products each bought.
 SELECT CustomerID,
        DistinctProductCount = COUNT(DISTINCT ProductCode)
   FROM #Purchase
  WHERE ProductCode IN ('A','B')
  GROUP BY CustomerID
;

--===== Find Customers that bought both "A" AND "B"
 SELECT CustomerID
   FROM #Purchase
  WHERE ProductCode IN ('A','B')
  GROUP BY CustomerID
 HAVING COUNT(DISTINCT ProductCode) = 2
 EXCEPT
--===== Find Customers that bought "C".
 SELECT CustomerID
   FROM #Purchase
  WHERE ProductCode IN ('C')
