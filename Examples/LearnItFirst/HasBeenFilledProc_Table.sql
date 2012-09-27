--CREATE TABLE CustomerProducPurchaseHistory
--(
--	OrderID INT NOT NULL
--	,CustomerID INT NOT NULL
--	,ProductID INT NOT NULL
--	,Quantity INT NOT NULL
--)
--GO

SELECT * FROM CustomerProducPurchaseHistory
DELETE CustomerProducPurchaseHistory


--CREATE TABLE FileProcessHistory
--(
--	LineID INT NOT NULL IDENTITY(1,1) PRIMARY KEY
--	,FileName NVARCHAR(128) NOT NULL
--	,ProcessDate DATETIME NOT NULL DEFAULT GETDATE()
--)
GO

--CREATE PROC HasFiileBeenProcessed
--(
--	@Filename NVARCHAR(128)
--	,@HasFileBeenProcessed BIT OUT -- output parameter
--)
--AS
--IF EXISTS (SELECT * FROM dbo.FileProcessHistory WHERE FileName=@FileName)
--	SET @HasFileBeenProcessed = 1 --True
--ELSE
--	SET @HasFileBeenProcessed = 0 --False
--GO



SELECT * FROM FileProcessHistory
DELETE FileProcessHistory