select * from openquery(gsfl2k,'select 
vmname,
imdesc,
imcolr,
imprcd,
imdiv,
imfmcd,

t.iritem, 
t.irdate as LastRecptDate, 
sum(t.irqty) as LastRecptQty,
(select sum(SLQSHP) from shline where slitem=t.iritem and sldate >= current_date - 90 days) as SalesQty

from itemrech t
inner join (
    select iritem, max(irdate) as MaxDate
    from itemrech
    where irdate >= ''1/1/2013''
    and irvend = 10131
    and irsrc = ''P''
    and irqty <> 0
    group by iritem
) tm on (t.iritem = tm.iritem and t.irdate = tm.MaxDate and irsrc = ''P'')

join itemmast on t.iritem = imitem
join vendmast on imvend = vmvend

group by 
vmname,
imdesc,
imcolr,
imprcd,
imdiv,
imfmcd,t.iritem,t.irdate

order by iritem
')

