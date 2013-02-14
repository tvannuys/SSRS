/*

Simple list of product codes and descriptions for a vendor

*/


create proc spProdCodeVendor 

@Vendor varchar(10)

as

declare @sql varchar(1000)

set @sql = '

select * from openquery(gsfl2k,''
select imprcd,pcdesc
from itemmast 
left join prodcode on imprcd = pcprcd
where imvend = ' + @Vendor + 
'group by imprcd,pcdesc
order by 1
'')'

exec(@sql)