select * from openquery(gsfl2k,'
select imitem,imprcd
from itemmast
where imitem = ''CULWCEG09A''
')

select * from openquery(gsfl2k,'
select imitem,imprcd, IMXPRODSUB, imdesc,imcolr,IMPTRN as ColorNum,IMP1, IMP2,IMP3,IMP4,IMP5,IMDrop,pcdesc
from itemmast
join itemxtra on IMXITM = imitem
join prodcode on pcprcd = imprcd
where imprcd = ''52038''
order by imdesc,imxprodsub, imitem
')

select * from openquery(gsfl2k,'
select *
from prodcode
where pcprcd = ''995''

')
