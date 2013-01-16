USE [Gartman]
GO

/****** Object:  StoredProcedure [dbo].[spIRRFinal]    Script Date: 01/08/2013 10:14:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Final Step and Select */

CREATE proc [dbo].[spIRRFinal] as

select 
IR.LineProdCodeDesc as 'Root Cause',
IR.LineDesc as 'Issue Code',
SUBSTRING(i.imdesc,charindex(':',i.IMDESC,1)+1,LEN(i.imdesc)) as DetailedIssue,
IRCS.Comments as 'Comments',
IR.SerialNum as Dept,
EC.ecPerson as AssociatedTo,
C.Comment1 as Employee,
IR.OrderCompany,
IR.ErrorLocation,
IR.[Order],
CONVERT(datetime, IR.OrderDate, 101) as OrderDate,
IR.ShipDate,
IR.ReportingLocation,
IR.Release,
IR.OrderType,
IR.InvoiceDate,
IR.CreatedBy,
IR.BillingCustomerID,
IR.CustomerID,
IR.SentToContact,
IR.LineOrder,
IR.LineRelease,
IR.LineProdCode,
IR.LineItem,
IR.Division,
IR.Quantity,
IR.[Source]

into IRRReportData

from IRRSalesOrder IR

left join ecirr EC on (IR.OrderCompany = EC.Company
	and IR.ReportingLocation = EC.ReportingLocation
	and IR.[Order] = EC.[Order]
	and IR.Release = EC.Release
	and IR.OrderDate = EC.OrderDate)
	
left join IRRCommentSummary IRCS on (IRCS.Company = IR.OrderCompany
	and IRCS.Location = IR.ReportingLocation
	and IRCS.[Order] = IR.[Order]
	and IRCS.Release = IR.Release)

left join irrcomments C on (C.Company = IR.OrderCompany
	and C.Location = IR.ReportingLocation
	and C.[Order] = IR.[Order]
	and C.Release = IR.Release
	and c.Comment1 like 'EM%')

left join itemmast I on SUBSTRING(ir.linedesc,1,5) = I.IMITEM



GO


