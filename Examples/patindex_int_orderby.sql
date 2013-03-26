

-- How to find first non numberic character
USE tempdb
GO
CREATE TABLE MyTable (ID INT, Col1 VARCHAR(100))
GO
INSERT INTO MyTable (ID, Col1)
SELECT 1, '1one'
UNION ALL
SELECT 2, '11eleven'
UNION ALL
SELECT 3, '2two'
UNION ALL
SELECT 4, '22twentytwo'
UNION ALL
SELECT 5, '111oneeleven'
GO
-- Select Data
SELECT *
FROM MyTable
GO


-- Select Data
SELECT *
FROM MyTable
ORDER BY Col1
GO


-- Use of PATINDEX
SELECT ID,
LEFT(Col1,PATINDEX('%[^0-9]%',Col1)-1) 'Numeric Character',
Col1 'Original Character'
FROM MyTable
ORDER BY LEFT(Col1,PATINDEX('%[^0-9]%',Col1)-1)
GO
-- Drop Temp Table
DROP TABLE MyTable
GO
