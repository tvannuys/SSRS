
--------------------------------------------------------
--
-- Create a PIVOT TABLE in T-SQL
--
--------------------------------------------------------

SELECT p.ProductID
	, ISNULL(p.[2001], 0) AS [2001]
	, ISNULL(p.[2002], 0) AS [2002]
	, ISNULL(p.[2003], 0) AS [2003]
	, ISNULL(p.[2004], 0) AS [2004] 
FROM (
	SELECT od.ProductId, od.LineTotal, YEAR(o.OrderDate) AS OrderYear
	FROM Sales.SalesOrderHeader o
	JOIN Sales.SalesOrderDetail od
		ON o.SalesOrderID = od.SalesOrderID
	WHERE od.ProductID BETWEEN 707 AND 712
) AS x
PIVOT (
	SUM(LineTotal)
	FOR OrderYear IN ([2001], [2002], [2003], [2004])
) p









-- Pivot on OrderYear as vertical axis; ProductId as horizontal axis
SELECT OrderYear
	, ISNULL(p.[707], 0) AS [707]
	, ISNULL(p.[708], 0) AS [708]
	, ISNULL(p.[709], 0) AS [709]
	, ISNULL(p.[710], 0) AS [710]
	, ISNULL(p.[711], 0) AS [711]
	, ISNULL(p.[712], 0) AS [712]
FROM (
	SELECT od.ProductId, od.LineTotal, YEAR(o.OrderDate) AS OrderYear
	FROM Sales.SalesOrderHeader o
	JOIN Sales.SalesOrderDetail od
		ON o.SalesOrderID = od.SalesOrderID
	WHERE od.ProductID BETWEEN 707 AND 712
) AS x
PIVOT (
	SUM(LineTotal)
	FOR ProductId IN ([707], [708], [709], [710], [711], [712])
) p