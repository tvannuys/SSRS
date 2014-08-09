USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spFindFaxContactDetails]    Script Date: 08/08/2014 17:34:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spFindFaxContactDetails] 

@FaxNum as varchar(20) = '9091'

as

declare @sql as varchar(max)

set @sql = 'select * from openquery(gsfl2k,''
select CCDFAX,ccdcus, cmname, ccddoc
from CUSTCNDTL
join custmast on ccdcus = cmcust
where CCDFAX like ''''%' + @FaxNum + '%''''
'')'

exec(@sql)
GO


