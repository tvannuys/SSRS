/*

7-28-14 - SR# 23712 - exclude transfers from On Order total, line below removed
	sum(IBQOOV) as QtyOnOrder,
	
spPurchasingItemStatus 'GAGVGM82012'

	
*/

USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spPurchasingItemStatus]    Script Date: 07/28/2014 10:01:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[spPurchasingItemStatus] 

@Item varchar(30)

as

declare @sql varchar(1000)

set @sql = 'select * from openquery(gsfl2k,''
select ibitem,
imdesc,
imcolr,
sum(ibqoh) as OnHand,

sum(IBQOOV) - (select sum(OLQORD) from ooline where OLOTYP <> ''''TR'''' and OLITEM = ibitem) as QtyOnOrder,
sum(IBQOH-IBQOO) AS QtyAvailable

from itembal
join itemmast on (itemmast.imitem = itembal.ibitem)
where ibitem = ' + '''''' + @Item + '''''' + 
' group by ibitem,imdesc,imcolr 


'')'

--select @sql
exec (@sql)

GO


