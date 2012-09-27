
DECLARE @DOW INT
SET @DOW = DATEPART(dw,GETDATE())

IF @DOW = 2 
BEGIN
	PRINT ' Monday go back 2 days'
END

ELSE 
	SELECT 'Not Monday only go back 1 day'
