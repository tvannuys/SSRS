

select * from openquery(gsfl2k,'
select vmvend,
vmname as Vendor,
iritem as Item,
IRDATE as LastReceiptDate,
sum(irqty) as LastReceiptQty,
(select sum(sleprc) 
	from shline 
	where slitem = iritem 
	and sldate = current_date - 90 days) as NinetyDaySales

from itemrech
join vendmast on IRVEND = vmvend

/* where iritem = ''MA38422'' */
/* where irpo# = ''153644''   */
where irqty <> 0
and irvend = 10131
and irsrc = ''P''

group by vmvend,
vmname,
iritem,
irdate

order by irdate desc

fetch first 1 rows only


')