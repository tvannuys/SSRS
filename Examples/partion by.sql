

------------ 
-- SQL calculate aggregates by SalesOrderID 
------------ 
-- SQL over partition by
USE AdventureWorks; 
GO 
SELECT   DISTINCT d.SalesOrderID, 
         [Total Quantity] = SUM(OrderQty) 
                              OVER(PARTITION BY d.SalesOrderID ), 
         [Average Quantity] = convert(VARCHAR,convert(MONEY,AVG(1.0 * OrderQty) 
                                 OVER(PARTITION BY d.SalesOrderID ), 
                                                      1)), 
         [Total Order Count] = COUNT(OrderQty) 
                                 OVER(PARTITION BY d.SalesOrderID ), 
         [Minimum Order Count] = MIN(OrderQty) 
                                   OVER(PARTITION BY d.SalesOrderID ), 
         [Maximum Order Count] = MAX(OrderQty) 
                                   OVER(PARTITION BY d.SalesOrderID ), 
         [Average Amount] = convert(VARCHAR,convert(MONEY,AVG(LineTotal) 
                             OVER(PARTITION BY d.SalesOrderID ), 
                                                    1)), 
         [Total Amount] = convert(VARCHAR,convert(MONEY,SUM(LineTotal) 
                             OVER(PARTITION BY d.SalesOrderID ), 
                                                  1)) 
FROM     Sales.SalesOrderDetail d 
         INNER JOIN Sales.SalesOrderHeader h 
           ON h.SalesOrderID = d.SalesOrderID 
         INNER JOIN Production.Product p 
           ON d.ProductID = p.ProductID 
WHERE    CustomerID = 100 
ORDER BY SalesOrderID
GO 
/* Partial results
 
SalesOrderID      Total Quantity    Average Quantity  Total Order Count
51818             81                2.61              31
57188             68                2.19              31
63290             68                2.96              23
69560             79                2.63              30
*/
