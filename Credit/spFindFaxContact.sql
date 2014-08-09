USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spFindFaxContact]    Script Date: 08/08/2014 17:34:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spFindFaxContact] 

@FaxNum as varchar(20)

as

declare @sql as varchar(max)

set @sql = 'select * from openquery(gsfl2k,''
select cncfax,cnccontid,cncfname, cmcust, cmname
from CONTCONT
join contxref on ccnxcontid = cnccontid
join custmast on ccnxacct = cmcust
where CNCFAX like ''''%' + @FaxNum + '%''''
'')'

exec(@sql)
GO


