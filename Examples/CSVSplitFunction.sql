---- http://www.geekzilla.co.uk/view5C09B52C-4600-4B66-9DD7-DCE840D64CBD.htm
--CREATE FUNCTION dbo.CSVToList (@CSV varchar(3000)) 
--    RETURNS @Result TABLE (Value varchar(30))
--AS   
--BEGIN
--    DECLARE @List TABLE
--    (
--        Value varchar(30)
--    )

--    DECLARE
--        @Value varchar(30),
--        @Pos int

--    SET @CSV = LTRIM(RTRIM(@CSV))+ ','
--    SET @Pos = CHARINDEX(',', @CSV, 1)

--    IF REPLACE(@CSV, ',', '') <> ''
--    BEGIN
--        WHILE @Pos > 0
--        BEGIN
--            SET @Value = LTRIM(RTRIM(LEFT(@CSV, @Pos - 1)))

--            IF @Value <> ''
--                INSERT INTO @List (Value) VALUES (@Value) 

--            SET @CSV = RIGHT(@CSV, LEN(@CSV) - @Pos)
--            SET @Pos = CHARINDEX(',', @CSV, 1)
--        END
--    END     

--    INSERT @Result
--    SELECT
--        Value
--    FROM
--        @List
    
--    RETURN
--END
-----------------------------------------------------------------------------------
ALTER PROC JT_CSV
 @CSV varchar(100)
AS
DECLARE @sql varchar(max)
SET @sql = 'SELECT *
FROM OPENQUERY(GSFL2K,''
					SELECT ohloc
						,ohord#
					FROM oohead
					'')
WHERE ohloc IN (SELECT * FROM dbo.CSVToList('''''+@CSV+'''''))'
EXEC(@sql)
GO
-- EXEC JT_CSV '2,3,4'
--------------------------------------------------------------- 
--> SSRS does not run all records while it does in BIDS <------
ALTER PROC JT_CSV2
 @CSV varchar(100)
 AS
SELECT *
FROM OPENQUERY(GSFL2K,'
					SELECT ohloc
						,ohord#
					FROM oohead
					')
WHERE ohloc IN (SELECT * FROM dbo.CSVToList(@CSV))

GO
-- EXEC JT_CSV2 '2,3,4'
-- 
