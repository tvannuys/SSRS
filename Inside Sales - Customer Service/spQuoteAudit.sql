

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spQuoteAudit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* join from OOLINE to Quotes using Product Code */
ALTER proc [dbo].[spQuoteAudit] 

@daysback as varchar(2) = ''1''

as

declare @sql as varchar(2000) 


set @sql = ''


select * from openquery(gsfl2k,''''

select
L.olCO as Company,
L.olLOC as Location,
L.olORD# as OrderNum,
L.olCUST as Customer,
L.olITEM as Item,
L.olDESC as ItemDesc,
L.olVend as Vendor,
L.olprcd as ProdCode,
L.olQT# as quote,
L.OLQORD as QuantityOrdered,

L.olpric as UnitPrice,
L.olcost as UnitCost,

Q.olitem as QuoteItem,
Q.olpric as QuotePrice,
Q.olcost as QuoteCost

from ooline L

join qsline Q on (q.olcust = L.olcust and Q.olprcd = L.olprcd and Q.olitem <> L.olitem)

where L.oldate = current_date - '' + @daysback + '' days
and L.olqt# <> 0

union  ''

/* join from OOLINE to Quotes using Item # */

set @sql = @sql + ''

select
L.olCO as Company,
L.olLOC as Location,
L.olORD# as OrderNum,
L.olCUST as Customer,
L.olITEM as Item,
L.olDESC as ItemDesc,
L.olVend as Vendor,
L.olprcd as ProdCode,
L.olQT# as quote,
L.OLQORD as QuantityOrdered,

L.olpric as UnitPrice,
L.olcost as UnitCost,

Q.olitem as QuoteItem,
Q.olpric as QuotePrice,
Q.olcost as QuoteCost

from ooline L

join qsline Q on (Q.olcust = L.olcust and Q.olitem = L.olitem)

where L.oldate = current_date - '' + @daysback + '' days
and L.olqt# <> 0

'''')

''


exec (@sql)


' 
END
GO


