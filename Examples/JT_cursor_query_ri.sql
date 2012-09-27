

DECLARE @Company INT
DECLARE @Location INT
DECLARE @Date DATE
DECLARE @Order INT
DECLARE @Release INT
DECLARE @User VARCHAR(10)

DECLARE curRIquery CURSOR FAST_FORWARD FOR

-- Query AS400 for order types RI & IR
SELECT ohco 'Company',
	ohloc 'Location',
	ohsdat 'Date',
	ohord# 'Order',
	ohrel# 'Release',
	ohuser 'User'
-- AS400 selections of order types
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM oohead
WHERE ohotyp IN(''RI'', ''IR'')
')

OPEN curRIquery
FETCH NEXT FROM curRIquery
INTO @Company, @Location, @Date, @Order, @Release, @User

WHILE @@FETCH_STATUS = 0
 BEGIN
	INSERT INTO dbo.ri_order 
		SELECT @Company, @Location, @Date, @Order, @Release, @User 
		WHERE @Order NOT IN (SELECT [Order] FROM dbo.ri_order)
	FETCH NEXT FROM curRIquery
		INTO @Company, @Location, @Date, @Order, @Release, @User
END
	

-- CLOSE curRIquery
-- DEALLOCATE curRIquery


GO


-- SELECT * FROM ri_order
-- DELETE FROM ri_order WHERE User = 'LUKED'