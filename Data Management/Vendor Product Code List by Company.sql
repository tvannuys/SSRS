select * from openquery(gsfl2k,'
select vmname,pcprcd,pcdesc,count(imitem)

from itemmast
left join itemxtra on imxitm = imitem
left join vendmast on imvend = vmvend
left join prodcode on pcprcd = imprcd

where  IMCOLIMIT in (2,0)
group by vmname,pcprcd,pcdesc
order by 4 desc
')
