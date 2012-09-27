

-- SQL Server UPDATE table with values from another table - QUICK SYNTAX
-- T-SQL multiple tables update - SQL Server inner join update 
UPDATE sod
  SET sod.ModifiedDate = soh.ModifiedDate 
FROM AdventureWorks2008.Sales.SalesOrderHeader soh
  INNER JOIN AdventureWorks2008.Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
-- (121317 row(s) affected)
------------
-- SQL Server update from another table - sql server insert another table 
-- Create table with SELECT INTO for testing - Price is increased with $1.00 
USE tempdb;
SELECT ProductID, ProductName = Name, ListPrice = ListPrice + 1.00
INTO Product
FROM AdventureWorks2008.Production.Product
GO
-- (504 row(s) affected)
SELECT ZeroPrice=COUNT(*) FROM Product WHERE ListPrice = 0
-- 0
 
-- SQL update from another table - two tables update sql server 
-- Restore original price only when it is 1.0 - Leave other prices increased
UPDATE p 
SET p.ListPrice = aw8.ListPrice 
FROM Product p
INNER JOIN AdventureWorks2008.Production.Product aw8
ON p.ProductID = aw8.ProductID
WHERE p.ListPrice = 1.00
GO
-- (200 row(s) affected)
 
SELECT ZeroPrice=COUNT(*) FROM Product WHERE ListPrice = 0
GO
-- 200
DROP TABLE tempdb.dbo.Product
