USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spCustPriceRefCodes]    Script Date: 09/26/2013 16:07:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[spCustPriceRefCodes]


@CustID varchar(10)

as

declare @sql varchar(max)

set @sql = 'select * from openquery (gsfl2k,''

select p.pecust as CustNum,
		p.peref# as PriceRefCode,
		c.cmname as PriceRefDesc
		
from pricexcp p
join custmast c on p.peref# = c.cmcust

where p.peref# <>''''''''
	and p.pecust = ''''' + @CustID + '''''

'')'

exec(@sql)
GO


