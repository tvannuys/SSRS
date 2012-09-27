
DECLARE @ClientID VARCHAR(10)
SET @ClienID = 1


DECLARE @xml AS NVARCHAR(MAX)
DECLARE @InvoiceInfo NVARCHAR(MAX)
DECLARE @Vendor NVARCHAR(MAX)
DECLARE @Client NVARCHAR(MAX)
DECLARE @Itmes NVARCHAR(MAX)
DECLARE @BalanceDue NVARCHAR(MAX)

SET @InvoiceInfo = (
SELECT DISTINCT 
	InvoiceNumber
	, CONVERT(VARCHAR(10), InvoiceDate,101) AS InvoiceDate
FROM [InvoiceDemo].[dbo].[Sales]
WHERE ClientID = @ClientID
FOR XML PATH('InvoiceInfo')
)

SET @Vendor =
(
SELECT VendorName, Address, City, [State], ZipCode, Phone
FRON [InvoiceDemo].[dbo].[Vendor]
FOR XML PATH('Vendor')
)

SET @Client =
(
SELECT ClientID,ClientName,Address,City,[State],ZipCode,Phone
FOM [InvoiceDemo].[dbo].[Clients]
WHERE ClientID = 1
FOR XML PATH('Client')
)

