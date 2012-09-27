/*
-- By Karthikeyan Mani, 2012/03/13 
-- http://www.sqlservercentral.com/articles/Reporting+Services+(SSRS)/87058/
*/
-----------------------------------------------
-- CTE
-----------------------------------------------
WITH CTEMonth
AS
(
      SELECT 1 AS MonNum
      UNION ALL
      SELECT MonNum + 1 -- add month number to 1 recursively
      FROM CTEMonth
      WHERE MonNum < 12 -- just to restrict the monthnumber upto 12
)
SELECT
      MonNum,
      DATENAME(MONTH,DATEADD(MONTH,MonNum,0)- 1)[MonthName] -- function to list the monthname.
FROM CTEMonth
------------------------------------------------
/* STORED PROCEDURE ----------------------------
------------------------------------------------

CREATE PROCEDURE JT_GetMonthnames
AS
BEGIN
      SET NOCOUNT ON;
     
      SELECT
            MonNum,
            [MonthName]
      FROM vw_MonthNames -- call the CTE view
END
*/
------------------------------------------------------------------
/* VIEW ----------------------------------------------------------
------------------------------------------------------------------
CREATE VIEW vw_MonthNames
AS
WITH CTEMonth
AS
(
      SELECT 1 AS MonNum
      UNION ALL
      SELECT MonNum + 1 -- add month number to 1 recursively
      FROM CTEMonth
      WHERE MonNum < 12 -- just to restrict the monthnumber upto 12
)
SELECT
      MonNum,
      DATENAME(MONTH,DATEADD(MONTH,MonNum,0)- 1)[MonthName] -- function to list the monthname.
FROM CTEMonth
*/
-------------------------------------------------------------------------