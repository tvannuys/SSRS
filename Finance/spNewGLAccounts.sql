USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spNewGLAccounts]    Script Date: 02/12/2013 10:22:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--spNewGLAccounts 2012

/* 

used in SSRS report 'New GL Account'

*/

CREATE proc [dbo].[spNewGLAccounts] 

@year varchar(4)

as

declare @lastyear as int
declare @sql as varchar(1000)

--set @year = '2011'
set @lastyear = CAST(@year as int) - 1

set @sql = '
select * 
from openquery (GSFL2K,''
select glbal.gbgl#,
glbal.gbco,
glbal.gbloc,
glbal.gbyr,
glbal.gbopbl,
glbal.gba01,
glbal.gba02,
glbal.gba03,
g.gbco as Company,
g.gbloc as Location,
g.gbgl# as GLNum

from GLBAL 
left join GLBAL G on (G.gbco = GLBAL.gbco
	and glbal.gbloc = g.gbloc
	and glbal.gbgl# = g.gbgl#
	and g.gbyr = ' + CONVERT(varchar(4),@lastyear) + ')

where glbal.gbyr = ' + @year + '
and g.gbgl# is null
order by glbal.gbgl#,glbal.gbco,glbal.gbloc

'')'

exec(@sql)

GO


