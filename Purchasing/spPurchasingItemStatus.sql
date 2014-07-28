USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spPurchasingItemStatus]    Script Date: 07/28/2014 15:49:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--[spPurchasingItemStatus] 'GR1020961B'
alter proc [dbo].[spPurchasingItemStatus] 

@Item varchar(30)

as

declare @sql varchar(1000)

set @sql = 'select * from openquery(gsfl2k,''
select ibitem,
imdesc,
imcolr,
sum(ibqoh) as OnHand,

(select sum(PLQORD - PLQREC) from poline
	where PLDELT <> ''''C''''
	and plitem = ibitem) as QtyOnOrder,

sum(IBQOH-IBQOO) AS QtyAvailable

from itembal
join itemmast on (itemmast.imitem = itembal.ibitem)
where ibitem = ' + '''''' + @Item + '''''' + 
' group by ibitem,imdesc,imcolr 


'')'

--select @sql
exec (@sql)


GO


