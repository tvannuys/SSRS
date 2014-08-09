USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spFindFaxAcct]    Script Date: 08/08/2014 17:33:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spFindFaxAcct] 

@FaxNum as varchar(20)

as

declare @sql as varchar(max)

set @sql = 'select * from openquery(gsfl2k,''
select cmcust, cmname, cmfax
from custmast
where CMFAX like ''''%' + @FaxNum + '%''''
'')'

exec(@sql)

GO


