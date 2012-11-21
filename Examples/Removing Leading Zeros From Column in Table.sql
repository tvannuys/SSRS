
-- Removing Leading Zeros From Column in Table

USE tempdb
GO
-- Create sample table
CREATE TABLE Table1 (Col1 VARCHAR(100))
INSERT INTO Table1 (Col1)
SELECT '0001'
UNION ALL
SELECT '000100'
UNION ALL
SELECT '100100'
UNION ALL
SELECT '000 0001'
UNION ALL
SELECT '00.001'
UNION ALL
SELECT '01.001'
GO
-- Original data
SELECT *
FROM Table1
GO
-- Remove leading zeros
SELECT
SUBSTRING(Col1, PATINDEX('%[^0 ]%', Col1 + ' '), LEN(Col1))
FROM Table1
GO
-- Clean up
DROP TABLE Table1
GO
