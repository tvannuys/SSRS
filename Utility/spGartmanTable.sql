USE [pubs]
GO

/****** Object:  StoredProcedure [dbo].[spGartmanTable]    Script Date: 11/27/2012 04:29:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spGartmanTable]

@TableName as varchar(10)

as

declare @sql as varchar(1000)

set @sql = '

select * from openquery(GSFL2K,''

SELECT  table_name,table_owner,
column_name,
column_heading,
data_type,
length,
COLUMN_TEXT

FROM qsys2.SYSCOLUMNS 

WHERE TABLE_NAME = ''''' + @TableName + '''''
and table_schema = ''''GSFL2K''''

order by ordinal_position

'')
'

exec(@sql)



GO


