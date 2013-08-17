USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spDSVendorItems]    Script Date: 08/15/2013 14:10:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[spDSVendorItems]  

@Vendor varchar(6)

as

declare @sql varchar(2000)

set @sql = 'select * from openquery(gsfl2k,''
select imitem,
IMSKEY,
imdesc,
imp1 as Level1,
imp2 as Level2,
imp3 as Level3,
imp4 as Level4,
imp5 as Level5,

imcost as LandedCost,
imrcst as NetCost,
imcost-imrcst as Freight

from itemmast
where imvend=' + @Vendor + ''')' 

exec(@sql)


GO


