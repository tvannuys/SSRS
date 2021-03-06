/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [computer_type]	AS [Type]
	   ,[description]	AS [Name]
       ,[computer_name]	AS [Serial Number]

FROM [sysaid].[dbo].[computer]

WHERE [computer_type] IN ('RF','RF Gun','RF Printer')
	AND [description] = 'AP8'