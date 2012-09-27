-- T-SQL create comma delimited list from single column result - QUICK SYNTAX
SELECT ColorCommaDelimitedList = 
Stuff((SELECT ', ' + Color AS [text()] 
          FROM   
          (SELECT DISTINCT Color FROM AdventureWorks2008.Production.Product
           ) x
          For XML PATH ('')),1,1,'') 
/*
 ColorCommaDelimitedList
 Black, Blue, Grey, Multi, Red, Silver, Silver/Black, White, Yellow 
 */
------------
 
-- Using XML PATH & CTE (SQL Server 2005 and on) 
 
-- T-SQL create comma delimited list using CTE - Common Table Expression 
;WITH cteColor AS
(SELECT DISTINCT Color FROM AdventureWorks2008.Production.Product)
 SELECT ColorCommaDelimitedList = 
   Stuff((SELECT ', ' + Color AS [text()] 
            FROM cteColor  
            For XML PATH ('')),1,1,'') 
 /*
 ColorCommaDelimitedList
 Black, Blue, Grey, Multi, Red, Silver, Silver/Black, White, Yellow
 */
------------
 
-- Using COALESCE and local variable (SQL Server 2000 and before)
DECLARE  @YearList VARCHAR(MAX) 
 
SELECT   @YearList = COALESCE(@YearList + ', ','') + CAST(OrderYear AS VARCHAR(4)) 
FROM      (SELECT DISTINCT OrderYear = YEAR(OrderDate) 
            FROM   AdventureWorks2008.Sales.SalesOrderHeader) x 
ORDER BY OrderYear 
 
SELECT YearList = @YearList 
/* YearList
2001, 2002, 2003, 2004   */
----------
-- Using local variable (SQL Server 2000 and before) 
 
-- T-SQL creating comma delimited list with local variable & multiple statements 
USE AdventureWorks;
DECLARE @CommaLimitedList VARCHAR(MAX) = ''
SELECT @CommaLimitedList = Color + ', ' + @CommaLimitedList
FROM (SELECT DISTINCT Color FROM Production.Product WHERE Color is not null) x
SELECT CommaDelimitedList=@CommaLimitedList
GO
/*
CommaDelimitedList
Yellow, White, Silver/Black, Silver, Red, Multi, Grey, Blue, Black, 
*/
 ------------
 
-- Using XML PATH & correlated subquery for sublist 
 
-- Create comma delimited sublist
SELECT   Subcategory = ps.[Name], 
           ColorList = Stuff((SELECT DISTINCT  ', ' + Color AS [text()] 
                                    FROM AdventureWorks2008.Production.Product p 
                                    WHERE p.ProductSubcategoryID = ps.ProductSubcategoryID
                                    FOR XML PATH ('')),1,1,'') 
FROM      AdventureWorks2008.Production.ProductSubcategory ps
ORDER BY Subcategory; 
GO
/*
Subcategory                ColorList
....
Helmets                      Black, Blue, Red
Hydration Packs           Silver
Jerseys                      Multi, Yellow
....
*/
------------
-- Preparing spaces delimited list 
-- T-SQL make spaces delimited list of ProductNumbers 
SELECT Alpha.List.value('.','varchar(256)') AS DelimitedList 
FROM   (SELECT   TOP ( 5 ) ProductNumber + '    ' 
          FROM      AdventureWorks2008.Production.Product 
          ORDER BY ProductNumber DESC 
          FOR XML PATH(''), TYPE) AS Alpha(List); 
/* 
DelimitedList 
WB-H098    VE-C304-S    VE-C304-M    VE-C304-L    TT-T092    
*/
