USE [GartmanReport]
GO

/****** Object:  View [dbo].[CustomerCurrentMonthSales]    Script Date: 03/17/2013 13:11:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[CustomerCurrentMonthSales]
AS
SELECT dbo.CustomerSalesDetail.InvoiceDate, dbo.CustomerSalesDetail.Company, 
               dbo.CustomerSalesDetail.SalesName, dbo.CustomerSalesDetail.BillToCustID, dbo.CustomerSalesDetail.BillToCustName, dbo.CustomerSalesDetail.BillToCity, 
               dbo.CustomerSalesDetail.BillToState, dbo.CustomerSalesDetail.VendorNum, dbo.CustomerSalesDetail.VendorName, dbo.CustomerSalesDetail.FamilyCode, 
               dbo.CustomerSalesDetail.FamilyCodeDesc, dbo.CustomerSalesDetail.Division, dbo.CustomerSalesDetail.DivisionDesc, dbo.SalesDivision.SalesDivision, 
               SUM(dbo.CustomerSalesDetail.ExtendedPrice) AS Price, SUM(dbo.CustomerSalesDetail.ExtendedCost) AS Cost, SUM(dbo.CustomerSalesDetail.Profit) 
               AS Profit
FROM  dbo.CustomerSalesDetail LEFT OUTER JOIN
               dbo.SalesDivision ON dbo.CustomerSalesDetail.FamilyCode = dbo.SalesDivision.FamilyCode

WHERE (
		(
		year(InvoiceDate) = YEAR(getdate())-1 
		and MONTH(InvoiceDate) = MONTH(getdate()) 
		and DAY(InvoiceDate) <= DAY(getdate()-3)
		)
or
		(
		year(InvoiceDate) = YEAR(getdate()) 
		and MONTH(InvoiceDate) = MONTH(getdate()) 
		and DAY(InvoiceDate) <= DAY(getdate()-3)
		)
	)
	
AND (dbo.CustomerSalesDetail.Company = 1)


GROUP BY dbo.CustomerSalesDetail.InvoiceDate, dbo.CustomerSalesDetail.Company, 
               dbo.CustomerSalesDetail.BillToCustID, dbo.CustomerSalesDetail.BillToCustName, dbo.CustomerSalesDetail.BillToCity, dbo.CustomerSalesDetail.BillToState, 
               dbo.CustomerSalesDetail.VendorNum, dbo.CustomerSalesDetail.VendorName, dbo.CustomerSalesDetail.FamilyCode, dbo.CustomerSalesDetail.FamilyCodeDesc, 
               dbo.CustomerSalesDetail.Division, dbo.CustomerSalesDetail.DivisionDesc, dbo.CustomerSalesDetail.SalesName, dbo.SalesDivision.SalesDivision

--select * from CustomerCurrentMonthSales

GO


