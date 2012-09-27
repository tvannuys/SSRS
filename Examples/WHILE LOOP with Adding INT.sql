--use JAMEST
--GO

--CREATE TABLE TstTable
--( id INT IDENTITY (1,1)NOT NULL
--	,Fiel1 Int NULL
--)

DECLARE @intFlag INT
SET @intFlag = 1
WHILE (@intFlag < 10)
BEGIN
INSERT INTO TstTable (Fiel1)
	VALUES(@intFlag)
	SET @intFlag = @intFlag + 1
END
GO


SELECT * FROM TstTable		