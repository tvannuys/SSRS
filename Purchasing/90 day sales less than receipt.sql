select vmname as Vendor,
imdesc as ItemDesc,
imcolr as Color,
imprcd as ProdCode,
imdiv as Division,
imfmcd as Family,
IMORDQ as MinOrderQty,

iritem as Item, 
imsi as Stock,
LastRecptDate, 
LastRecptQty,
QtyAvailable,
isnull(SalesQty,0) as SalesQty


from openquery(gsfl2k,'select 
vmname,
imdesc,
imcolr,
imprcd,
imdiv,
imfmcd,
IMORDQ,

t.iritem, 
imsi,
t.irdate as LastRecptDate, 
sum(t.irqty) as LastRecptQty,
(select sum(SLQSHP) from shline where slitem=t.iritem and sldate >= current_date - 90 days) as SalesQty,
(select sum(isqoh-isqoo) from itemstat where isitem = t.iritem and isloc = 98) as QtyAvailable

from itemrech t
inner join (
    select iritem, max(irdate) as MaxDate
    from itemrech
    where irdate >= ''1/1/2013''
    /* and irvend = 10131  */
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
imfmcd,
IMORDQ,
t.iritem,
imsi,
t.irdate

order by iritem
')

where QtyAvailable <> 0
and SalesQty < LastRecptQty

