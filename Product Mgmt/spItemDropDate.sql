USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spItemDropDate]    Script Date: 09/25/2013 14:54:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER proc [dbo].[spItemDropDate]
@Item varchar(18)

as

declare @sql varchar (1000)


set @sql = 

'select * from openquery (gsfl2k,''

select	imitem as ItemNum,
		imdesc as ItemDesc,
		idrdat as DropEffDate,
		idrdrd as DropUpdateDate

from itemdrop 
	left join itemmast on imitem=idritm
	
where imitem = ''''' + @Item + '''''
	and imdrop = ''''D''''
	

'')'
exec(@sql)

GO


