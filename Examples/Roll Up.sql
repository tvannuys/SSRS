--SET NOCOUNT ON;
--USE tempdb;
--GO
--CREATE TABLE CheckRegistry (
--	CheckNumber smallint, 
--	PayTo varchar(20),
--	Amount money, 
--	CheckFor varchar(20),
--	CheckDate date);
--INSERT INTO CheckRegistry VALUES
--    (1000,'Seven Eleven',12.57,'Food','2011-07-12'),
--    (1001,'Costco',128.57,'Clothes','2011-07-15'),
--    (1002,'Costco',21.87,'Clothes','2011-07-18'),
--    (1003,'AT&T',69.23,'Utilities','2011-07-25'),
--    (1004,'Comcast',45.95,'Utilities','2011-07-25'),
--    (1005,'Northwest Power',69.18,'Utilities','2011-07-25'),
--    (1006,'StockMarket',59.25,'Food','2011-07-25'),
--    (1007,'Safeway',120.21,'Food','2011-07-28'),
--    (1008,'Albertsons',9.15,'Food','2011-08-02'),
--    (1009,'Amazon',158.34,'Clothes','2011-08-05'),
--    (1010,'Target',89.21,'Clothes','2011-08-06'),
--    (1011,'AT&T',69.23,'Utilities','2011-08-25'),
--    (1012,'Comcast',45.95,'Utilities','2011-08-25'),
--    (1013,'Nordstrums',259.12,'Clothes','2011-08-27'),
--    (1014,'AT&T',69.23,'Utilities','2011-09-25'),
--    (1015,'Comcast',45.95,'Utilities','2011-09-25'),
--    (1016,'Northwest Power',71.35,'Utilities','2011-09-25'),
--    (1017,'Safeway',123.25,'Food','2011-09-25'),
--    (1018,'Albertsons',65.11,'Food','2011-09-29'),
--    (1019,'McDonalds',12.57,'Food','2011-09-29'),
--    (1020,'AT&T',69.23,'Utilities','2011-10-25'),
--    (1021,'Comcast',45.95,'Utilities','2011-10-25'),
--    (1022,'Black Angus',159.23,'Food','2011-10-25'),
--    (1023,'TicketMasters',59.87,'Entertainment','2011-10-30'),
--    (1024,'WalMart',25.11,'Clothes','2011-10-31'),
--    (1025,'Albertsons',158.50,'Food','2011-10-31');
    
    
USE tempdb;
GO
SELECT COALESCE (CheckFor,'GRAND TOTAL') As CheckFor
     , SUM (Amount) AS Total
FROM CheckRegistry
GROUP BY ROLLUP (CheckFor);
----------------------------------------------
USE tempdb;
GO
SELECT MONTH(CheckDate) AS CheckMonth 
     , CheckFor
     , SUM (Amount) AS Total
FROM CheckRegistry
GROUP BY ROLLUP (MONTH(CheckDate),CheckFor);
-----------------------------------------------
USE tempdb;
GO
SELECT MONTH(CheckDate) AS CheckMonth 
     , CheckFor
     , PayTo
     , SUM (Amount) AS Total
FROM CheckRegistry
GROUP BY ROLLUP (MONTH(CheckDate),CheckFor,PayTo);
-----------------------------------------------------
USE tempdb;
GO
SELECT CheckFor
     , SUM (Amount) As Total
FROM CheckRegistry
GROUP BY CUBE(CheckFor);   
-----------------------------------------------------
USE tempdb;
GO
SELECT MONTH(CheckDate) AS CheckMonth 
     , CheckFor
     , SUM (Amount) AS Total
FROM CheckRegistry
GROUP BY CUBE (MONTH(CheckDate),CheckFor);
------------------------------------------------------
USE tempdb;
GO
SELECT MONTH(CheckDate) AS CheckMonth 
     , CheckFor
     , PayTo
     , SUM (Amount) AS Total
FROM CheckRegistry
GROUP BY CUBE (MONTH(CheckDate),CheckFor, PayTo);
------------------------------------------------------
USE tempdb;
GO
SELECT MONTH(CheckDate) AS CheckMonth 
     , CheckFor
     , SUM (Amount) AS Total
FROM CheckRegistry
GROUP BY GROUPING SETS (MONTH(CheckDate),CheckFor,());