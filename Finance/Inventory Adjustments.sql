select * from openquery(gsfl2k,'
select irvend,iritem,
irco,irloc,irky,irdesc,
year(irdate),irdate,
irserl,irbin,
irqty,
ircost,irsrc,
iruser,
iredat,iretim,
irreason,iardes

from ITEMRCHY
left join iareason on irreason=iareas
where irloc = 85
and irsrc = ''A''

order by irserl,irdate
')

